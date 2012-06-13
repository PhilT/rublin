require 'yaml'

class Rublin
  def initialize
    @config = YAML.load File.open "config/#{underscore(self.class.to_s)}.yml"
  end
  
  def underscore camel_case
    camel_case.gsub(/(.)([A-Z])/,'\1_\2').downcase    
  end
end
