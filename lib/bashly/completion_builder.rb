module Bashly
  class CompletionBuilder
    BUILTIN_PATTERN = /\A<([^>]+)>\z/

    def initialize(command, with_version: true)
      @command = command
      @with_version = with_version
      @patterns = []
      @options = {}
      @tokens = {}
      @token_sources = {}
    end

    def call
      add_command @command, inherited_global_groups: []

      result = { 'patterns' => @patterns }
      result['options'] = @options if @options.any?
      result['tokens'] = @tokens if @tokens.any?
      result
    end

  private

    def add_command(command, inherited_global_groups:)
      local_group = add_local_options command
      pattern_groups = inherited_global_groups.dup
      pattern_groups << local_group if local_group

      @patterns << pattern_for(command, pattern_groups) unless visible_default_command(command)

      child_global_groups = inherited_global_groups.dup
      if command.global_flags?
        global_group = add_global_options command
        child_global_groups << global_group if global_group
      end

      command.visible_commands.each do |child|
        add_default_command_pattern command, child, pattern_groups
        add_command child, inherited_global_groups: child_global_groups
      end
    end

    def pattern_for(command, option_groups)
      parts = [command_path(command)]
      parts.concat(option_groups.map { |group| "[#{group} options]" })
      parts.concat positional_tokens(command)
      parts.join ' '
    end

    def add_default_command_pattern(parent, command, parent_option_groups)
      return unless command.default

      default_group = add_default_options parent, command, parent_option_groups
      option_groups = default_group ? [default_group] : []

      @patterns << pattern_for_default_command(parent, command, option_groups)
    end

    def add_default_options(parent, command, parent_option_groups)
      local_group = add_local_options command
      group_names = parent_option_groups.dup
      group_names << local_group if local_group

      entries = group_names.flat_map { |name| @options[name] || [] }.uniq
      return if entries.empty?

      name = token_name "#{group_name(parent)}_#{group_name(command)}_default"
      @options[name] = entries
      name
    end

    def pattern_for_default_command(parent, command, option_groups)
      parts = [command_path(parent)]
      parts.concat(option_groups.map { |group| "[#{group} options]" })
      parts.concat positional_tokens(
        command,
        first_source_extra: static_source(parent.visible_command_aliases)
      )
      parts.join ' '
    end

    def command_path(command)
      command_chain(command).map.with_index do |item, index|
        index.zero? ? item.name : item.aliases.join('|')
      end.join ' '
    end

    def command_chain(command)
      result = []
      current = command
      while current
        result.unshift current
        current = current.parent_command
      end
      result
    end

    def add_local_options(command)
      entries = fixed_option_entries(command) + flag_option_entries(command.visible_flags, command)
      return if entries.empty?

      name = group_name command
      @options[name] = entries
      name
    end

    def add_global_options(command)
      entries = flag_option_entries command.visible_flags, command
      return if entries.empty?

      name = "#{group_name(command)}_global"
      @options[name] = entries
      name
    end

    def fixed_option_entries(command)
      return [] if !command.root_command? && command.catch_all.catch_help?

      entries = %w[--help|-h]
      entries << '--version|-v' if command.root_command? && @with_version
      entries
    end

    def flag_option_entries(flags, command)
      flags.map do |flag|
        token_name = flag_token_name flag, command
        flag.completion_option_entry token_name
      end
    end

    def flag_token_name(flag, command)
      return unless flag.arg || flag.allowed || flag.completions

      register_token flag.arg || flag.name, command, flag_source(flag)
    end

    def positional_tokens(command, first_source_extra: nil)
      command.args.map.with_index do |arg, index|
        source = arg_source arg, command
        source = merge_sources(first_source_extra, source) if index.zero? && first_source_extra
        token_name = register_token arg.name, command, source
        suffix = arg.repeatable ? '...' : nil
        "<#{token_name}>#{suffix}"
      end
    end

    def merge_sources(*sources)
      sources.compact.flatten.uniq
    end

    def flag_source(flag)
      return static_source(flag.allowed) if flag.allowed
      return completion_source(flag.completions) if flag.completions

      nil
    end

    def arg_source(arg, command)
      return static_source(arg.allowed) if arg.allowed
      return completion_source(arg.completions) if arg.completions
      return completion_source(command.completions) if command.completions

      nil
    end

    def static_source(values)
      Array(values).compact.map { |value| escape_static_source value }
    end

    def completion_source(values)
      Array(values).compact.map do |value|
        string = value.to_s
        builtin = string[BUILTIN_PATTERN, 1]

        if builtin
          "+#{builtin}"
        else
          escape_static_source string
        end
      end
    end

    def escape_static_source(value)
      string = value.to_s
      string.start_with?('+') ? "+#{string}" : string
    end

    def register_token(base_name, command, source)
      preferred = token_name base_name
      return preferred if register_token_name preferred, source

      scoped = token_name "#{group_name command}_#{base_name}"
      return scoped if register_token_name scoped, source

      suffix = 2
      loop do
        candidate = "#{scoped}_#{suffix}"
        return candidate if register_token_name candidate, source

        suffix += 1
      end
    end

    def register_token_name(name, source)
      if @token_sources.has_key? name
        return false unless @token_sources[name] == source
      else
        @token_sources[name] = source
        @tokens[name] = source
      end

      true
    end

    def group_name(command)
      token_name command.root_command? ? 'root' : command.action_name
    end

    def visible_default_command(command)
      command.visible_commands.find(&:default)
    end

    def token_name(value)
      value.to_s
        .gsub(/[^a-zA-Z0-9]+/, '_')
        .gsub(/\A_+|_+\z/, '')
        .downcase
    end
  end
end
