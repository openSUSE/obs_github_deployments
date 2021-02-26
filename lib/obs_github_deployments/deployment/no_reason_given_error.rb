# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    class NoReasonGivenError < StandardError
      def message
        "You need to provide a reason in order to lock the deployments"
      end
    end
  end
end
