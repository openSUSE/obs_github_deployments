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

          response = locked?(repository: options[:repository], token: options[:token])
          puts status_response(status: response ? "locked" : "unlocked")
        end

        private

        def locked?(repository:, token: )
          repository_owner, repository_name = repository.split('/')

          result = ObsGithubDeployments::API.Client.query(
            ObsGithubDeployments::API::Queries::LastDeploymentState,
            variables: { repository_owner: repository_owner, repository_name: repository_name },
            context: { access_token: token }
          )

          if result.errors.any?
            # TODO: Decide how we proceed with errors. Would "exit(1)" be enough?
            return 'ERROR'
          end

          # The safe navigation operator is needed for state since it's possible that there are no deployments for the repository
          state = result.data.repository.deployments.nodes.first.&state
          state == "queued"
        end
      end
    end
  end
end
