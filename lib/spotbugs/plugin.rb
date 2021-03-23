# frozen_string_literal: true

module Danger
  # Checks on your Gradle project's Java source files.
  # This is done using [SpotBugs](https://spotbugs.github.io)
  # Results are passed out as tables in markdown.
  #
  # @example Running SpotBugs with its basic configuration
  #
  #          spotbugs.report
  #
  # @example Running SpotBugs with a specific Gradle task or report file (glob accepted)
  #
  #          spotbugs.gradle_task = 'module:spotbugsRelease' # default: spotbugsRelease
  #          spotbugs.report_file = 'module/build/reports/spotbugs/release.xml' # default: app/build/reports/spotbugs/release.xml
  #          spotbugs.report
  #
  # @example Running SpotBugs with an array of report files (glob accepted)
  #
  #          spotbugs.report_files = ['modules/**/build/reports/spotbugs/release.xml', 'app/build/reports/spotbugs/release.xml']
  #          spotbugs.report
  #
  # @example Running SpotBugs without running a Gradle task
  #
  #          spotbugs.skip_gradle_task = true
  #          spotbugs.report
  #
  # @see  mathroule/danger-spotbugs
  # @tags java, android, spotbugs
  #
  class DangerSpotbugs < Plugin
    require_relative './entity/bug_instance'

    # Custom Gradle task to run.
    # This is useful when your project has different flavors.
    # Defaults to 'spotbugsRelease'.
    # @return [String]
    attr_writer :gradle_task

    # A getter for `gradle_task`, returning 'spotbugsRelease' if value is nil.
    # @return [String]
    def gradle_task
      @gradle_task ||= 'spotbugsRelease'
    end

    # Skip Gradle task.
    # If you skip Gradle task, for example project does not manage Gradle.
    # Defaults to `false`.
    # @return [Bool]
    attr_writer :skip_gradle_task

    # A getter for `skip_gradle_task`, returning false if value is nil.
    # @return [Boolean]
    def skip_gradle_task
      @skip_gradle_task ||= false
    end
  end
end
