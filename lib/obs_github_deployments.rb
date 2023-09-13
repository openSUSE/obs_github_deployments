# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("cli" => "CLI")
loader.setup

require "octokit"
require "active_support" # For file caching and .blank?
require "action_view" # For ActionView::Helpers::DateHelper

module ObsGithubDeployments
  class Error < StandardError; end
end
