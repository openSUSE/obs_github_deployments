# frozen_string_literal: true

require "dry/cli"

module ObsGithubDeployments
  module CLI
    module Commands
      extend Dry::CLI::Registry
      # register the commands and its command line
      register "check-lock", CheckLock, aliases: ["c", "-c"]
      register "version", Version, aliases: ["v", "-v", "--version"]
      register "lock", Lock, aliases: ["l", "-l", "--lock"]
      register "unlock", Unlock, aliases: ["u", "-u", "--unlock"]
    end
  end
end
