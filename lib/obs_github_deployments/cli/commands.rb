# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      extend Dry::CLI::Registry
      # register the commands and its command line
      register "version", Version, aliases: ["v", "-v", "--version"]
    end
  end
end
