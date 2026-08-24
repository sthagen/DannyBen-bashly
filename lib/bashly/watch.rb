require 'watchly'

module Bashly
  # File system watcher - an ergonomic wrapper around the Watchly gem
  class Watch
    attr_reader :interval, :targets

    def initialize(*targets, interval: nil)
      @targets = targets.empty? ? ['.'] : targets
      @interval = interval || default_interval
    end

    def on_change
      raise ArgumentError, 'block required' unless block_given?

      watcher.on_change do |changes|
        yield normalize(changes)
      end
    rescue ::Interrupt => e
      raise Bashly::Interrupt, cause: e
    end

  private

    def default_interval
      value = Settings.watch_latency.to_f
      value.positive? ? value : 0.1
    end

    def normalize(changes)
      {
        modified: changes.modified,
        added:    changes.added,
        removed:  changes.removed,
      }
    end

    def watcher = @watcher ||= Watchly::Watcher.new(*targets, interval:)
  end
end
