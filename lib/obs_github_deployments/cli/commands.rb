# frozen_string_literal: true

module ObsGithubDeployments
  module CLI
    module Commands
      extend Dry::CLI::Registry
      # register the commands and its command line
      register "check-lock", CheckLock, aliases: ["c", "-c"]
      register "version", Version, aliases: ["v", "-v", "--version"]
      register "lock", Lock, aliases: ["l", "-l", "--lock"]
      register "unlock", Unlock, aliases: ["u", "-u", "--unlock"]
      register "fail", Fail, aliases: ["f", "-f", "--fail"]
      register "succeed", Succeed, aliases: ["s", "-s", "--succeed"]
      register "list", List, aliases: ["li", "--list"]
    end
  end
end
