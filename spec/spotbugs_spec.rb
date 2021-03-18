# frozen_string_literal: true

require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerSpotBugs do
    it 'should be a plugin' do
      expect(Danger::DangerSpotBugs.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @spotbugs = @dangerfile.spotbugs
      end
    end
  end
end
