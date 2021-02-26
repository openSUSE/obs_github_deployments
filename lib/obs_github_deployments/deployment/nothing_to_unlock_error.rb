# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    class NothingToUnlockError < StandardError
      def message
        "Current deployment is not locked, nothing to do here"
      end
    end
  end
end
