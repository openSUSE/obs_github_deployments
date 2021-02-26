# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    class AlreadyLockedError < StandardError
      def message
        "Current deployment is already locked, please unlock the deployments first"
      end
    end
  end
end
