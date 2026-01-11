require 'listen'

module Bashly
  # File system watcher - an ergonomic wrapper around the Listen gem
  class Watch
    attr_reader :dirs, :options

    def initialize(*dirs, **options)
      @options = default_options.merge(options).freeze
      @dirs = dirs.empty? ? ['.'] : dirs
    end

    def on_change(&)
      start(&)
      wait
    ensure
      stop
    end

  private

    def default_options
      {
        force_polling: force_polling?,
        latency:       latency,
      }
    end

    def force_polling?
      !Settings.watch_evented
    end

    def latency
      value = Settings.watch_latency.to_f
      value.positive? ? value : 0.1
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

    def wait
      sleep
    rescue ::Interrupt => e
      raise Bashly::Interrupt, cause: e
    end

    def build_listener
      listen.to(*dirs, **options) do |modified, added, removed|
        yield changes(modified, added, removed)
      end
    end

    def changes(modified, added, removed)
      { modified:, added:, removed: }
    end

    def listen = Listen
  end
end
