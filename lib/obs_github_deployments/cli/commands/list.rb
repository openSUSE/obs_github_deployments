# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      class List < ObsCommand
        desc "List deployments for a GitHub repository"

        option :repository, default: ENV["GITHUB_REPOSITORY"],
                            desc: "GitHub repository name where deployments should get locked"
        option :token, default: ENV["GITHUB_TOKEN"],
                       desc: "GitHub authentication token used to authenticate against the API"

        def call(**options)
          check_options(options: options)
          puts "Deployments of #{options[:repository]}"
          ObsGithubDeployments::Deployment.new(repository: options[:repository],
                                               access_token: options[:token]).list
        end

        def required_keys
          %i[repository token]
        end
      end
    end
  end
end
