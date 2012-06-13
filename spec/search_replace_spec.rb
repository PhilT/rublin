require 'spec_helper'

describe 'SearchReplace' do
  before do
    FileUtils.mkdir_p('lib')
    FileUtils.mkdir_p('home')
    File.open('lib/source.rb', 'w') {|f| f.puts 'some source code in a file' }
    File.open('home/somefile', 'w') {|f| f.puts 'some text in a file' }
    File.open('home/anotherfile', 'w') {|f| f.puts 'non-matching text' }
  end

  describe 'search' do
    it 'finds matching string in files' do
      matches = SearchReplace.search('some')
      matches.must_equal [Pathname.new('home/somefile'), Pathname('lib/source.rb')]
    end
  end
end

