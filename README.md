# ObsGithubDeployments

[![openSUSE](https://circleci.com/gh/openSUSE/obs_github_deployments.svg?style=svg)](https://app.circleci.com/pipelines/github/openSUSE/obs_github_deployments)

CLI tool and wrapper to interact with GitHub deployments, used by the Ansible setup for the deployments of the [Open Build Service](https://openbuildservice.org) reference instance.

With ObsGithubDeploymnets you can:
- Get information about the last deployments (history).
- Get the status of the last deployment.
- Lock a deployment.
- Unlock a deployment.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'obs_github_deployments'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install obs_github_deployments

## Usage

From development environment:

To know the version of this gem:

```
ruby obs_github_deployments -v
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openSUSE/obs_github_deployments.
