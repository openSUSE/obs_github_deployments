# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class CheckLock < ObsCommand
        desc "Checks if the deployment is locked"

        option :repository,
               default: ENV["GITHUB_REPOSITORY"],
               desc: "The GitHub repository to check if locked"
        option :token,
               default: ENV["GITHUB_TOKEN"],
               desc: "GitHub authentication token used to authenticate against the API"

        def call(**options)
          raise_error("You need to provide a repository name") unless options[:repository]
          raise_error("You need to provide a token in order to authenticate") unless options[:token]

          deployment_status = client(repository: options[:repository], token: options[:token]).status
          if deployment_status.locked?
            puts status_response(status: "locked", reason: deployment_status.reason)
            exit 1
          else
            puts status_response(status: "unlocked")
          end
        end

        private

        def client(repository:, token:)
          ObsGithubDeployments::Deployment.new(repository: repository,
                                               access_token: token)
        end
      end
    end
  end
end
