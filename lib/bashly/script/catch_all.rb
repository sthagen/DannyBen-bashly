module Bashly
  module Script
    class CatchAll
      class << self
        def option_keys
          @option_keys ||= %i[label help required catch_help]
        end

        def from_config(config)
          options = case config
          when nil
            { enabled: false }
          when String
            { label: config }
          when Hash
            config.transform_keys(&:to_sym).slice(*option_keys)
          else
            {}
          end

          new(**options)
        end
      end

      def initialize(label: nil, help: nil, required: false, catch_help: false, enabled: true)
        @label = label
        @help = help
        @required = required
        @enabled = enabled
        @catch_help = catch_help
      end

      def enabled?
        @enabled
      end

      def label
        enabled? ? "#{@label&.upcase}..." : nil
      end

      def help
        enabled? ? @help : nil
      end

      def required?
        @required
      end

      def catch_help?
        @catch_help
      end

      def usage_string
        return nil unless enabled?

        required? ? "[--] #{label}" : "[--] [#{label}]"
      end
    end
  end
end
