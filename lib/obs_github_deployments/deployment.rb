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
      return false unless local_status

      DeploymentStatus.new(local_status)
      # TODO: handle the possible exceptions properly
    end

    def lock(reason:)
      raise ObsGithubDeployments::Deployment::NoReasonGivenError if reason.blank?

      deployment = latest

      if deployment.blank?
        create_and_set_state(state: "queued", payload: payload_reason(reason: reason))
        return true
      end

      deployment_status = latest_status

      raise ObsGithubDeployments::Deployment::PendingError if deployment_status.blank?
      raise ObsGithubDeployments::Deployment::AlreadyLockedError if deployment_status.state == "queued"

      true if create_and_set_state(state: "queued", payload: payload_reason(reason: reason))
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

    def create(payload:)
      options = { auto_merge: false }
      options[:payload] = payload if payload

      @client.create_deployment(@repository, @ref, options)
    end

    def add_state(deployment:, state:)
      options = { accept: "application/vnd.github.flash-preview+json" }
      options[:accept] = "application/vnd.github.ant-man-preview+json" if state == "inactive"

      @client.create_deployment_status(deployment.url, state, options)
    end

    def create_and_set_state(state:, payload:)
      deployment = create(payload: payload)
      add_state(deployment: deployment, state: state)
    end

    def payload_reason(reason:)
      "{\"reason\": \"#{reason}\"}"
    end
  end
end
