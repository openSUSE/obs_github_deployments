# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Unlock < ObsCommand
        desc "Unlock the deployment"

        option :repository,
               default: ENV["GITHUB_REPOSITORY"],
               desc: "GitHub repository name where deployments should be unlocked"
        option :token,
               default: ENV["GITHUB_TOKEN"],
               desc: "GitHub authentication token used to authenticate against the API"

        def call(**options)
          check_options(options: options)
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token]).unlock

          puts(status_response(status: "ok"))
        end

        def required_keys
          %i[repository token]
        end
      end
    end
  end
end
