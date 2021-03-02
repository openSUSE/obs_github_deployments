# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Unlock < ObsCommand
        desc "Unlock deployments for a specific GitHub repository"

        option :repository,
               default: ENV["GITHUB_REPOSITORY"],
               desc: "GitHub repository name where deployments should be unlocked"
        option :token,
               default: ENV["GITHUB_TOKEN"],
               desc: "GitHub authentication token used to authenticate against the API"

        def call(**options)
          raise_error("You need to provide a repository name") unless options[:repository]
          raise_error("You need to provide a token in order to authenticate") unless options[:token]

          client(repository: options[:repository], token: options[:token]).unlock
          puts status_response(status: "ok")
        end

        def client(repository:, token:)
          ObsGithubDeployments::Deployment.new(repository: repository,
                                               access_token: token)
        end
      end
    end
  end
end
