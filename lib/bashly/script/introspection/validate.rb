module Bashly
  module Script
    module Introspection
      module Validate
        # Returns an array of validations
        def validate
          return [] unless options['validate']

          result = options['validate']
          result.is_a?(Array) ? result : [result]
        end

        # Returns true if there are any validations defined
        def validate? = validate.any?
      end
    end
  end
end
