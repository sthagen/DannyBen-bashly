require 'listen'

module Bashly
  # File system watcher - an ergonomic wrapper around the Listen gem
  class Watch
    attr_reader :dirs, :options

    DEFAULT_OPTIONS = {
      force_polling: true,
      latency:       1.0,
    }.freeze

    def initialize(*dirs, **options)
      @options = DEFAULT_OPTIONS.merge(options).freeze
      @dirs = dirs.empty? ? ['.'] : dirs
    end

    def on_change(&)
      start(&)
      wait
    ensure
      stop
    end

  private

    def build_listener
      listen.to(*dirs, **options) do |modified, added, removed|
        yield changes(modified, added, removed)
      end
    end

    def start(&block)
      raise ArgumentError, 'block required' unless block

      @listener = build_listener(&block)
      @listener.start
    end

    def stop
      @listener&.stop
      @listener = nil
    end

    def changes(modified, added, removed)
      { modified:, added:, removed: }
    end

    def wait
      sleep
    rescue ::Interrupt => e
      raise Bashly::Interrupt, cause: e
    end

    def listen = Listen
  end
end
