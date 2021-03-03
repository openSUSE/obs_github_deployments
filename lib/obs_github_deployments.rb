# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.inflector.inflect("api" => "API")
loader.setup

require "octokit"
require "graphql/client"
require "graphql/client/http"
require "active_support/core_ext/object/blank"

module ObsGithubDeployments
  class Error < StandardError; end
end
