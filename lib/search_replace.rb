require './lib/rublin'
require 'pathname'

class SearchReplace < Rublin
  def initialize
    super
    @ignore = /(#{@config['ignore'].join('|')})/
  end
  
  def self.search regexp
    found = []
    Dir["**/*"].each do |filename|
      next if filename =~ @ignore || File.directory?(filename)
      content = File.read(filename)
      found << Pathname.new(filename).relative_path_from(Pathname.pwd) if content.scan(regexp).any?
    end
    found
  end

  def self.replace regexp, replacement
    changed = []
    Dir["**/*"].each do |filename|
      next if filename =~ @ignore || File.directory?(filename)
      content = File.read(filename)
      new_content = content.gsub(regexp, replacement)
      if content != new_content
        File.open(filename, 'w') {|f| f.puts new_content }
        changed << filename
      end
    end
    changed
  end
end

