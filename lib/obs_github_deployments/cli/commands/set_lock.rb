# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class SetLock < Dry::CLI::Command
        desc "Lock deployments for a specific GitHub repository"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments should get locked"
        option :ref, default: ENV["GITHUB_BRANCH"],
                     desc: "GitHub branch name the locked deployment is referring to"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"
        option :reason, required: true, desc: "Explain reasoning behind locking the deployment process"

        def call(**options)
          abort("You need to provide a repository name") unless options[:repository]
          abort("You need to provide a branch name") unless options[:ref]
          abort("You need to provide a token in order to authenticate") unless options[:token]

          begin
            ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                                 access_token: options[:token],
                                                 ref: options[:ref]).lock(reason: options[:reason])
          rescue ObsGithubDeployments::Deployment::PendingError,
                 ObsGithubDeployments::Deployment::AlreadyLockedError,
                 ObsGithubDeployments::Deployment::NoReasonGivenError => e
            abort(e.message)
          end
        end
      end
    end
  end
end
