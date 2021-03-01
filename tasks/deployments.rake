# frozen_string_literal: true

require "octokit"

DEFAULT_STATE = "pending"
DEFAULT_BRANCH = "main"

namespace :deployments do
  desc "Set initial configuration"
  task :config do
    @repo_name = ENV["GITHUB_TEST_REPOSITORY"]
    @access_token = ENV["GITHUB_TEST_TOKEN"]
    @client = Octokit::Client.new(access_token: @access_token)
  end

  desc "Create a deployment on a specific repository"
  task create_deployment: :config do
    @client.create_deployment(@repo_name, DEFAULT_BRANCH)
  end

  desc "Change the state of a specific deployment"
  task :change_state, [:state] => [:config] do |_, args|
    begin
      deployment_state = args.with_defaults(state: DEFAULT_STATE)
      options = { accept: "application/vnd.github.flash-preview+json" }
      deployment = @client.deployments(@repo_name).first
      puts @client.create_deployment_status(deployment.url, deployment_state[:state], options).state
    rescue Octokit::InvalidRepository
      puts "ERROR: No repository name specified. Please set the GITHUB_TEST_REPOSITORY environment variable."
    end
  end

  desc "Checks the state of a specific deployment"
  task check_state: :config do
    begin
      deployment = @client.deployments(@repo_name).first
      puts @client.deployment_statuses(deployment.url).first.state
    rescue Octokit::InvalidRepository
      puts "ERROR: No repository name specified. Please set the GITHUB_TEST_REPOSITORY environment variable."
    end
  end
end
