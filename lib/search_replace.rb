require './lib/rublin'
require 'pathname'

class SearchReplace < Rublin
  def initialize
    super
    @ignore = /(#{@config['ignore'].join('|')})/
  end
  
  def search regexp, file_pattern = nil
    search_or_replace :in => file_pattern, :for => regexp
  end

  def replace regexp, replacement, file_pattern = nil
    search_or_replace :in => file_pattern, :for => regexp, :with => replacement
  end
  
private
  def search_or_replace options
    pattern = options[:in] || '**/*'
    search = options[:for]
    replace = options[:with]
    
    matches = []
    Dir["**/*"].each do |filename|
      next if filename =~ @ignore || File.directory?(filename)
      content = File.read(filename)
      if content.scan(search).any?
        File.open(filename, 'w') {|f| f.puts content.gsub(search, replace) } if replace
        matches << Pathname.new(filename).relative_path_from(Pathname.pwd)
      end
    end
    matches
  end
end

