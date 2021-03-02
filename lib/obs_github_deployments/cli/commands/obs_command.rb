# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class ObsCommand < Dry::CLI::Command
        protected

        def status_response(status:, reason: "")
          { status: status, reason: reason }.to_json
        end

        def raise_error(message)
          raise(Dry::CLI::Error, message)
        end
      end
    end
  end
end
