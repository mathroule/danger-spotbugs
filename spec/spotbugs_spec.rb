# frozen_string_literal: true

require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerSpotbugs do
    it 'should be a plugin' do
      expect(Danger::DangerSpotbugs.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @spotbugs = @dangerfile.spotbugs
      end

      it 'Check default Gradle task' do
        expect(@spotbugs.gradle_task).to eq('spotbugsRelease')
      end

      it 'Set custom Gradle task' do
        @spotbugs.gradle_task = 'spotbugsDebug'
        expect(@spotbugs.gradle_task).to eq('spotbugsDebug')
      end

      it 'Check default skip Gradle task' do
        expect(@spotbugs.skip_gradle_task).to be_falsey
      end

      it 'Set custom skip Gradle task' do
        @spotbugs.skip_gradle_task = true
        expect(@spotbugs.skip_gradle_task).to be_truthy
      end

      it 'Check default root path' do
        expect(@spotbugs.root_path).to eq(Dir.pwd)
      end

      it 'Set custom root path' do
        @spotbugs.root_path = '/Users/developer/project'
        expect(@spotbugs.root_path).to eq('/Users/developer/project')
      end

      it 'Report without Gradle' do
        allow_any_instance_of(Danger::DangerSpotbugs).to receive(:target_files).and_return([])

        @spotbugs.report_file = 'spec/fixtures/spotbugs_report.xml'
        @spotbugs.skip_gradle_task = false

        expect { @spotbugs.report }.to raise_error('Could not find `gradlew` inside current directory')
      end

      it 'Report without existing report file' do
        allow_any_instance_of(Danger::DangerSpotbugs).to receive(:target_files).and_return([])

        @spotbugs.report_file = 'spec/fixtures/custom/spotbugs_report.xml'
        @spotbugs.skip_gradle_task = true

        expect { @spotbugs.report }.to raise_error('Could not find matching SpotBugs report files for ["spec/fixtures/custom/spotbugs_report.xml"] inside current directory')
      end

      it 'Report with report file' do
        # noinspection RubyLiteralArrayInspection
        target_files = [
          'app/src/main/java/com/github/sample/tools/Tools.java',
          'app/src/main/java/com/github/sample/MainActivity.java',
          'app/src/main/java/com/github/sample/view/ConversationAdapter.java'
        ]
        allow_any_instance_of(Danger::DangerSpotbugs).to receive(:target_files).and_return(target_files)

        @spotbugs.report_file = 'spec/fixtures/spotbugs_report.xml'
        @spotbugs.root_path = '/Users/developer/project/sample'
        @spotbugs.skip_gradle_task = true

        spotbugs_issues = @spotbugs.report
        expect(spotbugs_issues).not_to be_nil
        expect(spotbugs_issues.length).to be(4)

        pmd_issue1 = spotbugs_issues[0]
        expect(pmd_issue1).not_to be_nil
        expect(pmd_issue1.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.relative_path).to eq('app/src/main/java/com/android/sample/Tools.java')
        expect(pmd_issue1.violations).not_to be_nil
        expect(pmd_issue1.violations.length).to eq(1)
        expect(pmd_issue1.violations.first).not_to be_nil
        expect(pmd_issue1.violations.first.line).to eq(5)
        expect(pmd_issue1.violations.first.description).to eq("The utility class name 'Tools' doesn't match '[A-Z][a-zA-Z0-9]+(Utils?|Helper)'")

        pmd_issue2 = spotbugs_issues[1]
        expect(pmd_issue2).not_to be_nil
        expect(pmd_issue2.absolute_path).to eq('/Users/developer/sample/app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.relative_path).to eq('app/src/main/java/com/android/sample/MainActivity.java')
        expect(pmd_issue2.violations).not_to be_nil
        expect(pmd_issue2.violations.length).to eq(1)
        expect(pmd_issue2.violations.first).not_to be_nil
        expect(pmd_issue2.violations.first.line).to eq(39)
        expect(pmd_issue2.violations.first.description).to eq("Use equals() to compare strings instead of '==' or '!='")

        pmd_issue3 = spotbugs_issues[2]
        expect(pmd_issue3).not_to be_nil
        expect(pmd_issue3.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.relative_path).to eq('app/src/test/java/com/android/sample/ExampleUnitTest.java')
        expect(pmd_issue3.violations).not_to be_nil
        expect(pmd_issue3.violations.length).to eq(1)
        expect(pmd_issue3.violations.first).not_to be_nil
        expect(pmd_issue3.violations.first.line).to eq(15)
        expect(pmd_issue3.violations.first.description).to eq("The JUnit 4 test method name 'addition_isCorrect' doesn't match '[a-z][a-zA-Z0-9]*'")

        pmd_issue4 = spotbugs_issues[3]
        expect(pmd_issue4).not_to be_nil
        expect(pmd_issue4.absolute_path).to eq('/Users/developer/sample/app/src/test/java/com/android/sample/ToolsTest.java')
        expect(pmd_issue4.relative_path).to eq('app/src/test/java/com/android/sample/ToolsTest.java')
        expect(pmd_issue4.violations).not_to be_nil
        expect(pmd_issue4.violations.length).to eq(2)
        expect(pmd_issue4.violations[0]).not_to be_nil
        expect(pmd_issue4.violations[0].line).to eq(12)
        expect(pmd_issue4.violations[0].description).to eq("The JUnit 4 test method name 'getLabel_1' doesn't match '[a-z][a-zA-Z0-9]*'")
        expect(pmd_issue4.violations[1]).not_to be_nil
        expect(pmd_issue4.violations[1].line).to eq(18)
        expect(pmd_issue4.violations[1].description).to eq("The JUnit 4 test method name 'getLabel_2' doesn't match '[a-z][a-zA-Z0-9]*'")
      end
    end
  end
end
