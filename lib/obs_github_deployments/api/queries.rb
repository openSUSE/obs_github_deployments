module ObsGithubDeployments::API::Queries
  LastDeploymentState = ObsGithubDeployments::API.Client.parse <<-'GRAPHQL'
    query($repository_owner: String!, $repository_name: String!) {
      repository(owner: $repository_owner, name: $repository_name) {
        deployments(last: 1) {
          nodes {
            state
          }
        }
      }
    }
  GRAPHQL
end
