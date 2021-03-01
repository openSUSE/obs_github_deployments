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

          response = client(repository: options[:repository], token: options[:token]).locked?
          puts status_response(status: response ? "locked" : "unlocked")
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
