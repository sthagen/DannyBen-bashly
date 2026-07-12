require 'erb'
require 'yaml'

module YAML
  class << self
    def trusted_load(content)
      if YAML.respond_to? :unsafe_load
        YAML.unsafe_load content
      else
        YAML.load content
      end
    end

    def trusted_load_file(path)
      trusted_load File.read(path)
    end

    def load_erb_file(path)
      YAML.trusted_load ERB.new(File.read(path)).result
    end
  end
end
