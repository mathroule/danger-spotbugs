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

      it 'Report with report file' do
        # noinspection RubyLiteralArrayInspection
        target_files = [
          'app/src/main/java/com/github/sample/tools/Tools.java',
          'app/src/main/java/com/github/sample/MainActivity.java',
          'app/src/main/java/com/github/sample/model/Message.java',
          'app/src/main/java/com/github/sample/model/User.java',
          'app/src/main/java/com/github/sample/view/ConversationAdapter.java'
        ]
        allow_any_instance_of(Danger::DangerSpotbugs).to receive(:target_files).and_return(target_files)

        @spotbugs.report_file = 'spec/fixtures/spotbugs_report.xml'
        @spotbugs.root_path = '/Users/developer/project/sample/'
        @spotbugs.skip_gradle_task = true

        spotbugs_issues = @spotbugs.report
        expect(spotbugs_issues).not_to be_nil
        expect(spotbugs_issues.length).to be(10)

        spotbugs_issue1 = spotbugs_issues[0]
        expect(spotbugs_issue1.rank).to eq(6)
        expect(spotbugs_issue1.line).to eq(29)
        expect(spotbugs_issue1.type).to eq(:warn)
        expect(spotbugs_issue1.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/MainActivity.java')
        expect(spotbugs_issue1.relative_path).to eq('app/src/main/java/com/github/sample/MainActivity.java')
        expect(spotbugs_issue1.description).to eq('Possible null pointer dereference of MainActivity.conversationAdapter in com.github.sample.MainActivity.onCreate(Bundle)')

        spotbugs_issue2 = spotbugs_issues[1]
        expect(spotbugs_issue2.rank).to eq(6)
        expect(spotbugs_issue2.line).to eq(45)
        expect(spotbugs_issue2.type).to eq(:warn)
        expect(spotbugs_issue2.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue2.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue2.description).to eq('com.github.sample.model.Message.getProperties() may return null, but is declared @Nonnull')

        spotbugs_issue3 = spotbugs_issues[2]
        expect(spotbugs_issue3.rank).to eq(14)
        expect(spotbugs_issue3.line).to eq(0)
        expect(spotbugs_issue3.type).to eq(:warn)
        expect(spotbugs_issue3.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue3.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue3.description).to eq('Class com.github.sample.model.Message defines non-transient non-serializable instance field conversation')

        spotbugs_issue4 = spotbugs_issues[3]
        expect(spotbugs_issue4.rank).to eq(14)
        expect(spotbugs_issue4.line).to eq(0)
        expect(spotbugs_issue4.type).to eq(:warn)
        expect(spotbugs_issue4.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue4.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue4.description).to eq('Class com.github.sample.model.Message defines non-transient non-serializable instance field sender')

        spotbugs_issue5 = spotbugs_issues[4]
        expect(spotbugs_issue5.rank).to eq(6)
        expect(spotbugs_issue5.line).to eq(31)
        expect(spotbugs_issue5.type).to eq(:warn)
        expect(spotbugs_issue5.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue5.relative_path).to eq('app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue5.description).to eq('Possible null pointer dereference of Tools$Helper.string in com.github.sample.tools.Tools$Helper.setText(TextView)')

        spotbugs_issue6 = spotbugs_issues[5]
        expect(spotbugs_issue6.rank).to eq(8)
        expect(spotbugs_issue6.line).to eq(32)
        expect(spotbugs_issue6.type).to eq(:warn)
        expect(spotbugs_issue6.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue6.relative_path).to eq('app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue6.description).to eq('Read of unwritten field title in com.github.sample.tools.Tools$Helper.setText(TextView)')

        spotbugs_issue7 = spotbugs_issues[6]
        expect(spotbugs_issue7.rank).to eq(18)
        expect(spotbugs_issue7.line).to eq(23)
        expect(spotbugs_issue7.type).to eq(:warn)
        expect(spotbugs_issue7.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue7.relative_path).to eq('app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue7.description).to eq('Should com.github.sample.tools.Tools$Helper be a _static_ inner class?')

        spotbugs_issue8 = spotbugs_issues[7]
        expect(spotbugs_issue8.rank).to eq(12)
        expect(spotbugs_issue8.line).to eq(32)
        expect(spotbugs_issue8.type).to eq(:warn)
        expect(spotbugs_issue8.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue8.relative_path).to eq('app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue8.description).to eq('Unwritten field: com.github.sample.tools.Tools$Helper.title')

        spotbugs_issue9 = spotbugs_issues[8]
        expect(spotbugs_issue9.rank).to eq(18)
        expect(spotbugs_issue9.line).to eq(15)
        expect(spotbugs_issue9.type).to eq(:warn)
        expect(spotbugs_issue9.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue9.relative_path).to eq('app/src/main/java/com/github/sample/tools/Tools.java')
        expect(spotbugs_issue9.description).to eq('Should com.github.sample.tools.Tools$Other be a _static_ inner class?')

        spotbugs_issue10 = spotbugs_issues[9]
        expect(spotbugs_issue10.rank).to eq(5)
        expect(spotbugs_issue10.line).to eq(32)
        expect(spotbugs_issue10.type).to eq(:warn)
        expect(spotbugs_issue10.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/view/ConversationAdapter.java')
        expect(spotbugs_issue10.relative_path).to eq('app/src/main/java/com/github/sample/view/ConversationAdapter.java')
        expect(spotbugs_issue10.description).to eq('Bad comparison of nonnegative value with -1 in com.github.sample.view.ConversationAdapter.setConversations(ArrayList)')
      end

      it 'Report with report file not in target files' do
        # noinspection RubyLiteralArrayInspection
        target_files = [
          'app/src/main/java/com/github/sample/MainActivity.java',
          'app/src/main/java/com/github/sample/model/Message.java',
          'app/src/main/java/com/github/sample/model/User.java',
          'app/src/main/java/com/github/sample/view/ConversationAdapter.java'
        ]
        allow_any_instance_of(Danger::DangerSpotbugs).to receive(:target_files).and_return(target_files)

        @spotbugs.report_file = 'spec/fixtures/spotbugs_report.xml'
        @spotbugs.root_path = '/Users/developer/project/sample/'
        @spotbugs.skip_gradle_task = true

        spotbugs_issues = @spotbugs.report
        expect(spotbugs_issues).not_to be_nil
        expect(spotbugs_issues.length).to be(5)

        spotbugs_issue1 = spotbugs_issues[0]
        expect(spotbugs_issue1.rank).to eq(6)
        expect(spotbugs_issue1.line).to eq(29)
        expect(spotbugs_issue1.type).to eq(:warn)
        expect(spotbugs_issue1.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/MainActivity.java')
        expect(spotbugs_issue1.relative_path).to eq('app/src/main/java/com/github/sample/MainActivity.java')
        expect(spotbugs_issue1.description).to eq('Possible null pointer dereference of MainActivity.conversationAdapter in com.github.sample.MainActivity.onCreate(Bundle)')

        spotbugs_issue2 = spotbugs_issues[1]
        expect(spotbugs_issue2.rank).to eq(6)
        expect(spotbugs_issue2.line).to eq(45)
        expect(spotbugs_issue2.type).to eq(:warn)
        expect(spotbugs_issue2.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue2.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue2.description).to eq('com.github.sample.model.Message.getProperties() may return null, but is declared @Nonnull')

        spotbugs_issue3 = spotbugs_issues[2]
        expect(spotbugs_issue3.rank).to eq(14)
        expect(spotbugs_issue3.line).to eq(0)
        expect(spotbugs_issue3.type).to eq(:warn)
        expect(spotbugs_issue3.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue3.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue3.description).to eq('Class com.github.sample.model.Message defines non-transient non-serializable instance field conversation')

        spotbugs_issue4 = spotbugs_issues[3]
        expect(spotbugs_issue4.rank).to eq(14)
        expect(spotbugs_issue4.line).to eq(0)
        expect(spotbugs_issue4.type).to eq(:warn)
        expect(spotbugs_issue4.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue4.relative_path).to eq('app/src/main/java/com/github/sample/model/Message.java')
        expect(spotbugs_issue4.description).to eq('Class com.github.sample.model.Message defines non-transient non-serializable instance field sender')

        spotbugs_issue5 = spotbugs_issues[4]
        expect(spotbugs_issue5.rank).to eq(5)
        expect(spotbugs_issue5.line).to eq(32)
        expect(spotbugs_issue5.type).to eq(:warn)
        expect(spotbugs_issue5.absolute_path).to eq('/Users/developer/project/sample/app/src/main/java/com/github/sample/view/ConversationAdapter.java')
        expect(spotbugs_issue5.relative_path).to eq('app/src/main/java/com/github/sample/view/ConversationAdapter.java')
        expect(spotbugs_issue5.description).to eq('Bad comparison of nonnegative value with -1 in com.github.sample.view.ConversationAdapter.setConversations(ArrayList)')
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
