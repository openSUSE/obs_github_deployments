# frozen_string_literal: true

module ObsGithubDeployments
  class Deployment
    class ReasonTooLong < StandardError
      def message
        "Reason given is too long: Maximum reason length is 140 characters"
      end
    end
  end
end
