require 'spec_helper'

describe 'SearchReplace' do
  before do
    FileUtils.mkdir_p('config')
    FileUtils.mkdir_p('lib')
    FileUtils.mkdir_p('tmp')
    FileUtils.mkdir_p('home')
    File.open('config/search_replace.yml', 'w') {|f| f.puts ({'ignore' => ['tmp']}.to_yaml) }
    File.open('lib/source.rb', 'w') {|f| f.puts 'some source code in a file' }
    File.open('home/somefile', 'w') {|f| f.puts 'some text in a file' }
    File.open('tmp/source.rb', 'w') {|f| f.puts 'some source code in a file' }
    File.open('home/anotherfile', 'w') {|f| f.puts 'non-matching text' }
  end

  describe 'search' do
    it 'finds matching string in files' do
      matches = SearchReplace.new.search('some')
      matches.must_equal [Pathname.new('home/somefile'), Pathname('lib/source.rb')]
    end

    it 'finds string in other file' do
      matches = SearchReplace.new.search('matching')
      matches.must_equal [Pathname.new('home/anotherfile')]
    end
  end
  
  describe 'replace' do
    it 'replaces string in files' do
      matches = SearchReplace.new.replace 'some', 'not much'
      matches.must_equal [Pathname.new('home/somefile'), Pathname('lib/source.rb')]
      File.read('home/somefile').must_equal "not much text in a file\n"
      File.read('lib/source.rb').must_equal "not much source code in a file\n"
    end
    
    it 'searches with a regex and replaces some text using grouping' do
      matches = SearchReplace.new.replace /some (.*) in a/, '\1 in this'
      File.read('home/somefile').must_equal "text in this file\n"
      File.read('lib/source.rb').must_equal "source code in this file\n"
    end
  end
end

