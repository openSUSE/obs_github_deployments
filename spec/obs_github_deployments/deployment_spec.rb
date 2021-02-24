# frozen_string_literal: true

require "test_helper"

RSpec.describe ObsGithubDeployments::Deployment, :vcr do
  subject do
    ObsGithubDeployments::Deployment.new(repository: gh_test_repository,
                                         access_token: gh_test_access_token,
                                         ref: gh_test_branch)
  end

  describe "locked?" do
    it "returns true when deployment is locked" do
      expect(subject.locked?).to eq(true)
    end

    it "returns false when deployment is not locked" do
      expect(subject.locked?).to eq(false)
    end
  end
end
