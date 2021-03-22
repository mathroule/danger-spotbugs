# frozen_string_literal: true

require_relative '../spec_helper'

module SpotBugs
  require 'oga'

  describe BugInstance do
    it 'should initialize with first bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[0])

      expect(bug_instance.rank).to eq(6)
      expect(bug_instance.line).to eq(29)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/MainActivity.java')
      expect(bug_instance.description).to eq('Possible null pointer dereference of MainActivity.conversationAdapter in com.github.sample.MainActivity.onCreate(Bundle)')
    end

    it 'should initialize with second bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[1])

      expect(bug_instance.rank).to eq(6)
      expect(bug_instance.line).to eq(31)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/tools/Tools.java')
      expect(bug_instance.description).to eq('Possible null pointer dereference of Tools$Helper.string in com.github.sample.tools.Tools$Helper.setText(TextView)')
    end

    it 'should initialize with third bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[2])

      expect(bug_instance.rank).to eq(8)
      expect(bug_instance.line).to eq(32)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/tools/Tools.java')
      expect(bug_instance.description).to eq('Read of unwritten field title in com.github.sample.tools.Tools$Helper.setText(TextView)')
    end

    it 'should initialize with fourth bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[3])

      expect(bug_instance.rank).to eq(18)
      expect(bug_instance.line).to eq(23)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/tools/Tools.java')
      expect(bug_instance.description).to eq('Should com.github.sample.tools.Tools$Helper be a _static_ inner class?')
    end

    it 'should initialize with fifth bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[4])

      expect(bug_instance.rank).to eq(12)
      expect(bug_instance.line).to eq(32)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/tools/Tools.java')
      expect(bug_instance.description).to eq('Unwritten field: com.github.sample.tools.Tools$Helper.title')
    end

    it 'should initialize with sixth bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[5])

      expect(bug_instance.rank).to eq(18)
      expect(bug_instance.line).to eq(15)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/tools/Tools.java')
      expect(bug_instance.description).to eq('Should com.github.sample.tools.Tools$Other be a _static_ inner class?')
    end

    it 'should initialize with seventh bug instance' do
      xml = Oga.parse_xml(File.open('spec/fixtures/spotbugs_report.xml'))
      bug_instance = BugInstance.new(xml.xpath('//BugInstance')[6])

      expect(bug_instance.rank).to eq(5)
      expect(bug_instance.line).to eq(32)
      expect(bug_instance.type).to eq(:warn)
      expect(bug_instance.source_path).to eq('com/github/sample/view/ConversationAdapter.java')
      expect(bug_instance.description).to eq('Bad comparison of nonnegative value with -1 in com.github.sample.view.ConversationAdapter.setConversations(ArrayList)')
    end
  end
end
