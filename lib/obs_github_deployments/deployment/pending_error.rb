# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    class PendingError < StandardError
      def message
        "Current deployment is in state pending, please try again later"
      end
    end
  end
end
