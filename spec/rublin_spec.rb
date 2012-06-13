require 'spec_helper'

class ClassToLoadConfigFrom < Rublin
  attr_reader :config
end

describe Rublin do
  it 'loads config file using underscored name of class' do
    FileUtils.mkdir_p 'config'
    File.open('config/class_to_load_config_from.yml', 'w') { |f| f.puts 'some_config: a value' }
    subject = ClassToLoadConfigFrom.new
    subject.config['some_config'].must_equal 'a value'
  end
end
