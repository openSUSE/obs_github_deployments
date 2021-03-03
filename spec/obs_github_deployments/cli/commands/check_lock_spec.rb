# frozen_string_literal: true

require "test_helper"

RSpec.describe ObsGithubDeployments::CLI::Commands::CheckLock, :vcr do
  subject { described_class.new }

  describe "call" do
    it "raises an error when a repository isn't provided" do
      expect { subject.call }.to raise_error(Dry::CLI::Error, "You need to provide a repository name")
    end

    it "raises an error when a repository is provided, but not a token" do
      expect { subject.call(repository: gh_test_repository) }.to raise_error(Dry::CLI::Error, "You need to provide a token in order to authenticate")
    end

    context "when a repository and a token are provided through environment variables" do
      # TODO
    end

    context "when a repository and a token are provided through command-line options" do
      # TODO
      # it "" do
      #   expect(subject.call(repository: gh_test_repository, token: gh_test_access_token))
      # end
    end
  end
end
