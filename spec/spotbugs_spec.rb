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
    end
  end
end
