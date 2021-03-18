# Danger SpotBugs

Checks on your Gradle project's Java source files.
This is done using [SpotBugs](https://spotbugs.github.io)
Results are passed out as tables in markdown.

This plugin is inspired from https://github.com/kazy1991/danger-findbugs.

## Installation

    $ gem install danger-spotbugs

## Usage

    Methods and attributes from this plugin are available in
    your `Dangerfile` under the `spotbugs` namespace.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
