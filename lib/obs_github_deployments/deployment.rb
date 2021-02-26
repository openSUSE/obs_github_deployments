# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    attr_reader :client

    def initialize(repository:, access_token:)
      @client = Octokit::Client.new(access_token: access_token)
      @repository = repository
    end

    def locked?
      # Nothing stops us to deploy for the first time, so not having deployments means unlocked.
      local_status = latest_status
      return false unless local_status

      local_status.state == "queued"
      # TODO: handle the possible exceptions properly
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
  end
end
