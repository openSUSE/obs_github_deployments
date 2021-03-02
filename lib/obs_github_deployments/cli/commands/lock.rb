# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class Lock < ObsCommand
        desc "Lock deployments for a specific GitHub repository"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments should get locked"
        option :ref, default: ENV["GITHUB_BRANCH"],
                     desc: "GitHub branch name the locked deployment is referring to"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"
        option :reason, required: true, desc: "Explain reasoning behind locking the deployment process"

        def call(**options)
          check_options(options: options)
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token],
                                               ref: options[:ref]).lock(reason: options[:reason])

          puts(status_response(status: "ok", reason: options[:reason]))
        end

        private

        def check_options(options:)
          unless %i[
            repository ref token
          ].all? do |key|
                   options[key].present?
                 end
            raise_error("You need to provide the respository name, branch and token")
          end
        end
      end
    end
  end
end
