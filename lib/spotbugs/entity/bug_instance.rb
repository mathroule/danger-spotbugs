# frozen_string_literal: true

# Represent a BugInstance.
class BugInstance
  RANK_ERROR_THRESHOLD = 4
  attr_reader :relative_path
  attr_accessor :source_dirs, :bug_instance

  def initialize(prefix, source_dirs, bug_instance)
    @source_dirs = source_dirs
    @bug_instance = bug_instance

    source_path = bug_instance.xpath('SourceLine').attribute('sourcepath').first.value.to_s
    absolute_path = get_absolute_path(source_path)
    prefix += (prefix.end_with?(file_separator) ? '' : file_separator)
    @relative_path = if absolute_path.start_with?(prefix)
                       absolute_path[prefix.length, absolute_path.length - prefix.length]
                     else
                       absolute_path
                     end
  end

  def rank
    @rank ||= bug_instance.attribute('rank').value.to_i
  end

  def type
    @type ||= rank > RANK_ERROR_THRESHOLD ? :warn : :fail
  end

  def line
    @line ||= bug_instance.xpath('SourceLine').attribute('start').first.value.to_i
  end

  def description
    @description ||= bug_instance.xpath('LongMessage').text
  end

  private

  def get_absolute_path(source_path)
    @source_dirs.map do |source_dir|
      return source_dir if source_dir.end_with?(source_path)
    end
  end

  def file_separator
    File::ALT_SEPARATOR || File::SEPARATOR
  end
end
