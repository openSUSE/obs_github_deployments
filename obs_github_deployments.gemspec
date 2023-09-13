# frozen_string_literal: true

require_relative "lib/obs_github_deployments/version"

Gem::Specification.new do |spec|
  spec.name          = "obs_github_deployments"
  spec.version       = ObsGithubDeployments::VERSION
  spec.authors       = ["Lukas Krause"]
  spec.email         = ["lkrause@suse.de"]

  spec.summary       = "CLI tool and wrapper to interact with GitHub deployments."
  spec.description   = "CLI tool and wrapper to interact with GitHub deployments,
                        used by the Ansible setup for the deployments of the
                        Open Build Service reference instance."
  spec.homepage      = "https://github.com/openSUSE/obs_github_deployments"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry-byebug", "~> 3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rubocop-rake", "~> 0.5"
  spec.add_development_dependency "rubocop-rspec", "~> 2.2"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3"
  spec.add_dependency "actionview"
  spec.add_dependency "activesupport"
  spec.add_dependency "dry-cli", ">= 0.6", "< 2.0"
  spec.add_dependency "octokit", ">= 4.22", "< 7.0"
  spec.add_dependency "zeitwerk", "~> 2.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
