# Danger SpotBugs
[![Latest release](https://img.shields.io/github/v/release/mathroule/danger-spotbugs.svg)](https://github.com/mathroule/danger-spotbugs/releases/latest) [![Deploy](https://github.com/mathroule/danger-spotbugs/workflows/Deploy/badge.svg)](https://github.com/mathroule/danger-spotbugs/actions) [![codecov](https://codecov.io/gh/mathroule/danger-spotbugs/branch/main/graph/badge.svg?token=KW312ANXPN)](https://codecov.io/gh/mathroule/danger-spotbugs)

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
