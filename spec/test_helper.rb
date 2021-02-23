# frozen_string_literal: true

require "vcr"
require "webmock"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<GITHUB_TOKEN>") { gh_test_access_token }
  config.filter_sensitive_data("<GITHUB_REPOSITORY>") { gh_test_repository }
end

def gh_test_access_token
  ENV.fetch("GITHUB_TEST_TOKEN", "x" * 40)
end

def gh_test_repository
  ENV.fetch("GITHUB_TEST_REPOSITORY", "krauselukas/test_github_deployments")
end
