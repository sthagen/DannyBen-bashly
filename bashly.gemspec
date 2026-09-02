lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'bashly/version'

Gem::Specification.new do |s|
  s.name        = 'bashly'
  s.version     = Bashly::VERSION
  s.summary     = 'Bash command-line framework and CLI generator'
  s.description = 'Generate bash command line tools using YAML configuration'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.executables = ['bashly']
  s.homepage    = 'https://bashly.dev'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.3'

  s.add_dependency 'colsole', '~> 1.0'
  s.add_dependency 'gtx', '~> 0.1.1'
  s.add_dependency 'mister_bin', '~> 0.9.0'
  s.add_dependency 'requires', '~> 1.1'
  s.add_dependency 'tty-markdown', '~> 0.7.2'
  s.add_dependency 'watchly', '~> 0.2.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/bashly-framework/bashly/issues',
    'changelog_uri'         => 'https://github.com/bashly-framework/bashly/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://bashly.dev/',
    'source_code_uri'       => 'https://github.com/bashly-framework/bashly',
    'rubygems_mfa_required' => 'true',
  }
end
