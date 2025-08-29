require 'shellwords'

module Bashly
  module Script
    class Argument < Base
      include Introspection::Validate

      class << self
        def option_keys
          @option_keys ||= %i[
            allowed default help name repeatable required unique validate
          ]
        end
      end

      def default_string
        if default.is_a?(Array)
          Shellwords.shelljoin default
        elsif default.is_a?(String) && repeatable
          Shellwords.shellescape default
        else
          default
        end
      end

      def label
        repeatable ? "#{name.upcase}..." : name.upcase
      end

      def usage_string
        required ? label : "[#{label}]"
      end
    end
  end
end
