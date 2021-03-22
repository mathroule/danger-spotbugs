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
  class DangerSpotBugs < Plugin
    require_relative './entity/bug_instance'
  end
end
