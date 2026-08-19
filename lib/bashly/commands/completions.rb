module Bashly
  module Commands
    class Completions < Base
      summary 'Display bash completions for bashly itself'

      usage 'bashly completions'
      usage 'bashly completions (-h|--help)'

      def run
        puts script
      end

    private

      def script
        @script ||= asset_content('completions/bashly-completions.bash')
      end
    end
  end
end
