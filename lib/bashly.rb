require 'requires'
requires 'bashly/extensions'
requires 'bashly/exceptions'

module Bashly
  autoloads 'bashly/refinements', %i[ComposeRefinements]

  autoloads 'bashly', %i[
    CLI Config ConfigValidator Library LibrarySource
    LibrarySourceConfig MessageStrings RenderContext RenderSource Settings
    VERSION Watch
  ]

  autoloads 'bashly/concerns', %i[
    AssetHelper Renderable ValidationHelpers
  ]

  module Script
    autoloads 'bashly/script', %i[
      Argument Base CatchAll Command Dependency EnvironmentVariable Flag
      Formatter Variable Wrapper
    ]

    module Introspection
      autoloads 'bashly/script/introspection', %i[
        Arguments Commands Dependencies EnvironmentVariables Examples Flags
        Validate Variables Visibility
      ]
    end
  end

  module Commands
    autoloads 'bashly/commands', %i[
      Add Base Completions Doc Generate Init Preview Render Shell Validate
    ]
  end

  module Libraries
    autoload :Base, 'bashly/libraries/base'
    autoload :Help, 'bashly/libraries/help/help'
  end
end
