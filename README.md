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

Require the gem whenever you need it:

```ruby
    require 'obs_github_deployments'
```

Most of the commands require the credentials to access the GitHub repository where you are going to track the deployments. You can obtain the token in GitHub: `Settings > Developer Settings > Personal access tokens`.
It is enough to enable `repo:status` and `repo_deployment` scopes.

You can pass them using the corresponding flags as we do in this example:

```
obs_github_deployments unlock --repository $GITHUB_REPOSITORY --token $GITHUB_TOKEN
```

But you could also set them as environment variables in the `.env` file taking `.env.example` as example. Doing so you don't need to specify them in the command:

```
obs_github_deployments unlock
```

To know the version of this gem:

```
obs_github_deployments -v
```

You can unlock a locked deployment at any time with:

```
obs_github_deployments unlock --repository $GITHUB_REPOSITORY --token $GITHUB_TOKEN
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### With Docker

Run `make docker-dev` and you'll be dropped inside a shell with all needed dependencies to build and hack the gem.

## Testing

We are using `Rspec` in combination with the `VCR` gem to test our code. The `VCR` gem will mock the GitHub API responses, in order
to have consistent, fast and stable test results.
First time you run spec's that require a "real" API response from GitHub, VCR will record the response and create
a cassette (a `.yml` file with the response content) in the `spec/cassettes` folder, which is going to mock
the API in future runs of the test. Therefore you need to work with real credentials and GitHub API communication
on the initial test execution.

**Important:** Since we are working with real credentials and auth tokens, we need to filter them out of the cassettes
before commiting anything to a public repository. You can do so, by using the `filter_sensitive_data` option
which replaces the real value with a given string when the cassette is recorded. This is set in the `VCR`
configuration in the `spec/test_helper.rb` file. Please double check the cassettes for any sensible data before commiting them!

### Recording the cassettes:

The `test_helper.rb` file contains the configuration of `VCR` and some helper methods to
use your credentials for the GitHub API by loading them from enviroment variables.

1. Rename the `.env.test.example` to `.env.test` and fill the enviroment variables
in the file accordingly.
2. Load the enviroment variables by sourcing the the env file `source .env.test`

To use `VCR` in your tests, simply require the `test_helper.rb` file in your specs. There are
different ways to enable mocking through the VCR cassettes in your tests, one of them is just
to enable it in the `describe` block:

Example:
```
RSpec.describe ObsGithubDeployments::Deployment, :vcr do
end
```

First time you run your test case, it will do a real API call and record the response. Incase
your test case/code changed, you might need to re-record them. Simply delete the corresponding cassette
and `VCR` will record a new one for you on the next execution of the test case.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openSUSE/obs_github_deployments.
