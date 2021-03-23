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
  #          spotbugs.gradle_task = 'module:spotbugsRelease' # default: 'spotbugsRelease'
  #          spotbugs.report_file = 'module/build/reports/spotbugs/release.xml' # default: 'app/build/reports/spotbugs/release.xml'
  #          spotbugs.report
  #
  # @example Running SpotBugs with a specific root path
  #
  #          spotbugs.root_path = '/Users/developer/project' # default: result of `git rev-parse --show-toplevel`
  #          spotbugs.report
  #
  # @example Running SpotBugs with an array of report files (glob accepted)
  #
  #          spotbugs.report_files = ['modules/**/build/reports/spotbugs/release.xml', 'app/build/reports/spotbugs/release.xml']
  #          spotbugs.report
  #
  # @example Running SpotBugs without running a Gradle task
  #
  #          spotbugs.skip_gradle_task = true # default: false
  #          spotbugs.report
  #
  # @example Running SpotBugs without inline comment
  #
  #          spotbugs.report(inline_mode: false) # default: true
  #
  # @see  mathroule/danger-spotbugs
  # @tags java, android, spotbugs
  #
  class DangerSpotbugs < Plugin
    require_relative './entity/bug_instance'

    # Custom Gradle task to run.
    # This is useful when your project has different flavors.
    # Defaults to 'spotbugsRelease'.
    #
    # @return [String]
    attr_writer :gradle_task

    # A getter for `gradle_task`, returning 'spotbugsRelease' if value is nil.
    #
    # @return [String]
    def gradle_task
      @gradle_task ||= 'spotbugsRelease'
    end

    # Skip Gradle task.
    # If you skip Gradle task, for example project does not manage Gradle.
    # Defaults to `false`.
    #
    # @return [Bool]
    attr_writer :skip_gradle_task

    # A getter for `skip_gradle_task`, returning false if value is nil.
    #
    # @return [Boolean]
    def skip_gradle_task
      @skip_gradle_task ||= false
    end

    # An absolute path to a root.
    # To comment errors to VCS, this needs to know relative path of files from the root.
    # Defaults to result of 'git rev-parse --show-toplevel'.
    #
    # @return [String]
    attr_writer :root_path

    # A getter for `root_path`, returning result of `git rev-parse --show-toplevel` if value is nil.
    #
    # @return [String]
    def root_path
      @root_path ||= `git rev-parse --show-toplevel`.chomp
    end

    # Location of report file.
    # If your SpotBugs task outputs to a different location, you can specify it here.
    # Defaults to 'app/build/reports/spotbugs/release.xml'.
    #
    # @return [String]
    attr_writer :report_file

    # A getter for `report_file`, returning 'app/build/reports/spotbugs/release.xml' if value is nil.
    #
    # @return [String]
    def report_file
      @report_file ||= 'app/build/reports/spotbugs/release.xml'
    end

    # Location of report files.
    # If your SpotBugs task outputs to a different location, you can specify it here.
    # Defaults to ['app/build/reports/spotbugs/release.xml'].
    #
    # @return [Array[String]]
    attr_writer :report_files

    # A getter for `report_files`, returning ['app/build/reports/spotbugs/release.xml'] if value is nil.
    #
    # @return [Array[String]]
    def report_files
      @report_files ||= [report_file]
    end

    # Calls SpotBugs task of your Gradle project.
    # It fails if `gradlew` cannot be found inside current directory.
    # It fails if `report_file` cannot be found inside current directory.
    # It fails if `report_files` is empty.
    #
    # @param [Boolean] inline_mode Report as inline comment, defaults to [true].
    #
    # @return [Array[PmdFile]]
    def report(inline_mode: true)
      unless skip_gradle_task
        raise('Could not find `gradlew` inside current directory') unless gradlew_exists?

        exec_gradle_task
      end

      report_files_expanded = Dir.glob(report_files).sort
      raise("Could not find matching SpotBugs report files for #{report_files} inside current directory") if report_files_expanded.empty?

      do_comment(report_files_expanded, inline_mode)
    end

    private

    # Check gradlew file exists in current directory.
    #
    # @return [Boolean]
    def gradlew_exists?
      !`ls gradlew`.strip.empty?
    end

    # Run Gradle task.
    #
    # @return [void]
    def exec_gradle_task
      system "./gradlew #{gradle_task}"
    end

    # A getter for `spotbugs_report`, returning SpotBugs report.
    #
    # @param [String] report_file The report file.
    #
    # @return [Oga::XML::Document]
    def spotbugs_report(report_file)
      require 'oga'
      Oga.parse_xml(File.open(report_file))
    end

    # A getter for current updated files.
    #
    # @return [Array[String]]
    def target_files
      @target_files ||= (git.modified_files - git.deleted_files) + git.added_files
    end

    # A getter for SpotBugs issues, returning SpotBugs issues.
    #
    # @param [String] report_file The report file.
    #
    # @return [Array[BugInstance]]
    def spotbugs_issues(report_file)
      spotbugs_report = spotbugs_report(report_file)

      source_dirs = spotbugs_report.xpath('//BugCollection//SrcDir').map(&:text)

      spotbugs_report.xpath('//BugCollection//BugInstance').map do |bug_instance|
        BugInstance.new(root_path, source_dirs, bug_instance)
      end
    end

    # Generate report and send inline comment with Danger's warn or fail method.
    #
    # @param [Boolean] inline_mode Report as inline comment, defaults to [true].
    #
    # @return [Array[PmdFile]]
    def do_comment(report_files, inline_mode)
      puts "do_comment report_files: #{report_files}"
      puts "do_comment inline_mode: #{inline_mode}"

      spotbugs_issues = []

      report_files.each do |report_file|
        puts "do_comment report_file: #{report_file}"
        puts "do_comment target_files: #{target_files}"
        spotbugs_issues(report_file).each do |bug_instance|
          puts "do_comment bug_instance: #{bug_instance}"
          puts "do_comment bug_instance.source_path: #{bug_instance.source_path}"
          puts "do_comment bug_instance.relative_path: #{bug_instance.relative_path}"
          next unless target_files.include? bug_instance.relative_path

          spotbugs_issues.push(bug_instance)

          send_comment(bug_instance, inline_mode)
        end
      end

      spotbugs_issues
    end

    def send_comment(bug_instance, inline_mode)
      if inline_mode
        send(bug_instance.type, bug_instance.description, file: bug_instance.relative_path, line: bug_instance.line)
      else
        send(bug_instance.type, "#{bug_instance.relative_path} : #{bug_instance.description} at #{bug_instance.line}")
      end
    end
  end
end
