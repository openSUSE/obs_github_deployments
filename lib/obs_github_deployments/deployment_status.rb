# frozen_string_literal: true

module ObsGithubDeployments
  class DeploymentStatus
    attr_reader :reason

    # This is basically a null object meaning no deployment status exist.
    # It will return false when asked if locked?
    def self.none
      new("state" => "", "description" => "")
    end

    def initialize(status)
      @state = status["state"]
      @reason = status["description"]
    end

    def locked?
      @state == "queued"
    end
  end
end
