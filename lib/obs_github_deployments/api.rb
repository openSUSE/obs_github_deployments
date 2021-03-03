# Schema and Client are class methods to prevent crashes when the code is loaded: https://github.com/github/graphql-client/issues/181
module ObsGithubDeployments::API
  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(context)
      { "Authorization": "bearer #{context[:access_token]}" }
    end
  end

  def self.Schema
    # TODO: The schema is available here: https://github.com/octokit/graphql-schema/blob/master/schema.json
    #       It's only difference is a missing root "data" key which is containing the schema.
    #       This can be done with the following command in the root of our project:
    #         curl 'https://raw.githubusercontent.com/octokit/graphql-schema/master/schema.json' | jq '{ "data": . }' >> schema.json
    #
    #       We could always keep track of the latest version instead of having to dump it ourselves.
    #       This could be automated through a bot, see GitHub example: https://github.com/octokit/graphql-schema/pull/440
    #       or with graphql-inspector https://graphql-inspector.com/docs/essentials/diff#examples
    #       This approach allows us to completely ignore access tokens to update the schema, which is a pain since there are no access tokens for GitHub organizations
    #
    @schema ||= GraphQL::Client.load_schema('schema.json')

    # TODO: Alternative to the solution above. It would also need to be automated, but it's more difficult to track when the schema changed.
    #       We would need to manage an access token, which is a pain since there are no access tokens for GitHub organizations. So only one person can manage this.
    # Dumping the schema should be done somewhere else, maybe a rake task as recommended in upstream in graphql-client's documentation.
    # The access token is not available in the headers (see above), even though it's passed here.
    # Somehow the changes from https://github.com/github/graphql-client/pull/196 don't work. For now, we pass the access token in the context of every query.
    # @schema ||= GraphQL::Client.load_schema(GraphQL::Client.dump_schema(HTTP, nil, context: { access_token: ENV.fetch('GITHUB_TOKEN', 'NO ACCESS TOKEN PROVIDED') }))
  end

  def self.Client
    @client ||= GraphQL::Client.new(schema: self.Schema, execute: HTTP)
  end
end
