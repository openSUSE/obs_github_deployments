# frozen_string_literal: true

module ObsGithubDeployments
  class DeploymentStatus
    attr_reader :reason

    def initialize(status)
      @state = status["state"]
      @reason = status["description"]
    end

    def locked?
      @state == "queued"
    end
  end
end
