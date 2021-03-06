# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class ObsCommand < Dry::CLI::Command
        DEFAULT_ERROR = "You need to provide the respository name, branch and token"

        private

        def check_options(options:)
          raise_error(DEFAULT_ERROR) unless (options.keys - required_keys).empty?
        end

        def required_keys
          %i[repository ref token reason]
        end

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
