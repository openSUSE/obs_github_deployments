# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Succeed < ObsCommand
        desc "Inform GitHub Deployments that the OBS deployment succeeded"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments are tracked"
        option :ref, default: ENV["GITHUB_BRANCH"],
                     desc: "GitHub branch name the deployment is referring to"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"
        option :reason, required: true, desc: "Why deployment succeed?", default: "obs deployed successfully"

        def call(**options)
          check_options(options: options)
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token],
                                               ref: options[:ref]).succeed(reason: options[:reason])

          puts(status_response(status: "ok", reason: options[:reason]))
        end
      end
    end
  end
end
