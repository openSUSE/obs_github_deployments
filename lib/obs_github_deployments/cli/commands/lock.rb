# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Lock < ObsCommand
        desc "Lock the deployment"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments should get locked"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"
        option :reason, required: true, desc: "Explain reasoning behind locking the deployment process"

        def call(**options)
          check_options(options: options)
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token]).lock(reason: options[:reason])

          puts(status_response(status: "ok", reason: options[:reason]))
        end

        def required_keys
          %i[repository token reason]
        end
      end
    end
  end
end
