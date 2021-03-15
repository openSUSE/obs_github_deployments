# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Fail < ObsCommand
        desc "Lock deployments for a specific GitHub repository"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments should get locked"
        option :ref, default: ENV["GITHUB_BRANCH"],
                     desc: "GitHub branch name the locked deployment is referring to"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"
        option :reason, required: true, desc: "Why deployment failed?", default: "obs deployment failed"

        def call(**options)
          check_options(options: options)
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token],
                                               ref: options[:ref]).fail(reason: options[:reason])

          puts(status_response(status: "ok", reason: options[:reason]))
        end
      end
    end
  end
end
