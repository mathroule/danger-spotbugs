# frozen_string_literal: true

# Represent a BugInstance.
class BugInstance
  RANK_ERROR_THRESHOLD = 4
  attr_accessor :bug_instance

  def initialize(bug_instance)
    @bug_instance = bug_instance
  end

  def rank
    @rank ||= bug_instance.attribute('rank').value.to_i
  end

  def type
    @type ||= rank > RANK_ERROR_THRESHOLD ? :warn : :fail
  end

  def source_path
    @source_path ||= bug_instance.xpath('SourceLine').attribute('sourcepath').first.value.to_s
  end

  def line
    @line ||= bug_instance.xpath('SourceLine').attribute('start').first.value.to_i
  end

  def description
    @description ||= bug_instance.xpath('LongMessage').text
  end
end
