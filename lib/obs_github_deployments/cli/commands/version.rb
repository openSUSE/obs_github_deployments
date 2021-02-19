# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      # Version command
      class Version < Dry::CLI::Command
        desc "Print obs_gihub_deployments gem version"
        def call(*)
          puts ObsGithubDeployments::VERSION
        end
      end
    end
  end
end
