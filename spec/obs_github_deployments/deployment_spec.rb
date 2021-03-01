# frozen_string_literal: true

require "test_helper"

RSpec.describe ObsGithubDeployments::Deployment, :vcr do
  subject(:deployment) do
    described_class.new(repository: gh_test_repository,
                        access_token: gh_test_access_token,
                        ref: gh_test_branch)
  end

  describe "locked?" do
    it "returns true when deployment is locked" do
      expect(deployment.locked?).to eq(true)
    end

    it "returns false when deployment is not locked" do
      expect(deployment.locked?).to eq(false)
    end
  end

  describe "lock" do
    context "without providing a reason" do
      it "throws an exception" do
        expect { deployment.lock(reason: nil) }.to raise_error(
          ObsGithubDeployments::Deployment::NoReasonGivenError
        )
      end
    end

    context "with a pending deployment" do
      before do
        # Deployment without a set state ends up being in state pending
        deployment.send :create, payload: nil
      end

      it "throws an exception" do
        expect { deployment.lock(reason: "Wait for PR#12345") }.to raise_error(
          ObsGithubDeployments::Deployment::PendingError
        )
      end
    end

    context "with an already locked deployment in place" do
      before do
        deployment.send :create_and_set_state, state: "queued", payload: nil
      end

      it "throws an exception" do
        expect { deployment.lock(reason: "Wait for PR#12345") }.to raise_error(
          ObsGithubDeployments::Deployment::AlreadyLockedError
        )
      end
    end

    context "without pending or locked deployment in place" do
      before do
        deployment.send :create_and_set_state, state: "success", payload: nil
      end

      it "locks the deployment" do
        expect(deployment.lock(reason: "Wait for PR#12345")).to eq(true)
        expect(deployment.send(:latest_status).state).to eq("queued")
        expect(deployment.send(:latest).payload).to eq("{\"reason\": \"Wait for PR#12345\"}")
      end
    end
  end

  describe "unlock" do
    context "with an deployment not in the locked state" do
      before do
        deployment.send :create_and_set_state, state: "success", payload: nil
      end

      it "throws an exception" do
        expect { deployment.unlock }.to raise_error(
          ObsGithubDeployments::Deployment::NothingToUnlockError
        )
      end
    end

    context "with an deployment without any state set" do
      before do
        deployment.send :create, payload: nil
      end

      it "throws an exception" do
        expect { deployment.unlock }.to raise_error(
          ObsGithubDeployments::Deployment::NothingToUnlockError
        )
      end
    end

    context "with a locked deployment in place" do
      before do
        deployment.send :create_and_set_state, state: "queued", payload: nil
      end

      it "unlocks the deployment and returns true" do
        expect(deployment.unlock).to eq(true)
        expect(deployment.send(:latest_status).state).to eq("inactive")
      end
    end
  end
end
