# frozen_string_literal: true
include ActionView::Helpers::DateHelper

module ObsGithubDeployments
  class Deployment
    attr_reader :client

    def initialize(repository:, access_token:, ref: "main")
      @client = Octokit::Client.new(access_token: access_token)
      @repository = repository
      @ref = ref
      @file_cache = ActiveSupport::Cache::FileStore.new(File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'cache'))
    end

    def list
      @previous = {}
      all.reverse.each do |deployment|
        unless @previous[:commit] # skip the first deployment, we have nothing to compare it too...
          @previous[:commit] = deployment[:sha]
          @previous[:created_at] = deployment[:created_at]
          next
        end
        size = deployment.dig(:payload, :total_commits)
        size ||= @file_cache.fetch(deployment[:sha]) do
          total_commits(base: @previous[:commit], head: deployment[:sha])
        end
        puts "At #{deployment[:created_at].strftime("%A")} #{deployment[:created_at]} after #{distance_of_time_in_words(deployment[:created_at], @previous[:created_at])} #{deployment[:creator][:login]} deployed #{size} commits to #{deployment[:environment]}"
        @previous[:commit] = deployment[:sha]
        @previous[:created_at] = deployment[:created_at]
      end
    end

    def status
      # Nothing stops us to deploy for the first time, so not having deployments means unlocked.
      local_status = latest_status
      return DeploymentStatus.none unless local_status

      DeploymentStatus.new(local_status)
      # TODO: handle the possible exceptions properly
    end

    def fail(reason:)
      create_and_set_state(state: "failure", reason: reason)
    end

    def succeed(reason:)
      create_and_set_state(state: "success", reason: reason)
    end

    def lock(reason:)
      raise ObsGithubDeployments::Deployment::NoReasonGivenError if reason.blank?
      raise ObsGithubDeployments::Deployment::ReasonTooLong if reason.length > 140

      deployment = latest

      if deployment.blank?
        create_and_set_state(state: "queued", reason: reason)
        return true
      end

      deployment_status = latest_status

      raise ObsGithubDeployments::Deployment::PendingError if deployment_status.blank?
      raise ObsGithubDeployments::Deployment::AlreadyLockedError if deployment_status.state == "queued"

      true if create_and_set_state(state: "queued", reason: reason)
    end

    def unlock
      deployment_status = latest_status

      if deployment_status.blank? || deployment_status.state != "queued"
        raise ObsGithubDeployments::Deployment::NothingToUnlockError
      end

      add_state(deployment: latest, state: "inactive")
      true
    end

    private

    def all
      deployments = client.deployments(@repository, environment: "production", per_page: 100)
      last_response = client.last_response
      until last_response.rels[:next].nil?
        last_response = last_response.rels[:next].get
        deployments.concat(last_response.data)
      end

      deployments
    end

    def latest
      @client.deployments(@repository, per_page: 1, environment: "production").first
    end

    def latest_status
      @client.deployment_statuses(latest.url).first if latest
    end

    def total_commits(base: latest[:sha], head: @ref)
      @client.compare(@repository, base, head)[:total_commits]
    end

    def minutes_since_latest
      ((Time.now.utc - latest[:created_at]) / 1.minute).round
    end

    def create
      # auto_merge: Do not merge the default branch into the requested deployment branch if necessary
      # required_contexts: Do not verify if CI status checks passed on the master branch.  This allows us to create a
      #                    deployment, even if somehow codecov failed or we have a flickering spec.
      options = { auto_merge: false, required_contexts: [] }

      @client.create_deployment(@repository, @ref, options)
    end

    def add_state(deployment:, state:, description: nil)
      options = { accept: "application/vnd.github.flash-preview+json" }
      options[:accept] = "application/vnd.github.ant-man-preview+json" if state == "inactive"
      options[:description] = description if description.present?

      @client.create_deployment_status(deployment.url, state, options)
    end

    def create_and_set_state(state:, reason:)
      deployment = create
      add_state(deployment: deployment, state: state, description: reason)
    end
  end
end
