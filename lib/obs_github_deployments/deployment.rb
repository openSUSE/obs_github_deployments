# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    attr_reader :client

    def initialize(repository:, access_token:, ref: "main")
      @client = Octokit::Client.new(access_token: access_token)
      @repository = repository
      @ref = ref
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

      @ref = lastest_commit # we just always use the latest ref to lock

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
      client.deployments(@repository)
    end

    def latest
      all.first
    end

    def latest_status
      client.deployment_statuses(latest.url).first if latest
    end

    def lastest_commit
      @client.commits(@repository, options = {per_page: 1})
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
