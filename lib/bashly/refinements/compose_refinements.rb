module ComposeRefinements
  refine Hash do
    def compose(keyword = 'import')
      result = {}
      each do |k, v|
        if k.to_s == keyword
          sub = safe_load_yaml(v).compose keyword
          if sub.is_a? Array
            result = sub
          else
            result.merge! sub
          end
        elsif v.respond_to? :compose
          result[k] = v.compose keyword
        else
          result[k] = v
        end
      end
      result
    end

    def safe_load_yaml(path)
      loaded = YAML.load_erb_file path
      return loaded if loaded.is_a?(Array) || loaded.is_a?(Hash)

      raise Bashly::ConfigurationError, "Cannot find a valid YAML in g`#{path}`"
    rescue Errno::ENOENT
      raise Bashly::ConfigurationError, "Cannot find import file g`#{path}`"
    end
  end

  refine Array do
    def compose(keyword = 'import')
      map do |x|
        if x.respond_to? :compose
          x.compose keyword
        else
          x
        end
      end
    end
  end
end
