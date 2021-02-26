# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      # CheckLockedDeployments command
      class CheckLockedDeployments < Dry::CLI::Command
        desc "Return a successful exit status (0) only if deployments are locked"
        def call(*)
          deployment = ObsGithubDeployments::Deployment.new(repository: ENV.fetch("GITHUB_REPOSITORY"),
                                                            access_token: ENV.fetch("GITHUB_TOKEN"),
                                                            ref: ENV.fetch("GITHUB_BRANCH"))

          exit 1 unless deployment.locked?
        end
      end
    end
  end
end
