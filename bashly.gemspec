lib = File.expand_path 'lib', __dir__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'bashly/version'

Gem::Specification.new do |s|
  s.name        = 'bashly'
  s.version     = Bashly::VERSION
  s.summary     = 'Bash Command Line Tool Generator'
  s.description = 'Generate bash command line tools using YAML configuration'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*']
  s.executables = ['bashly']
  s.homepage    = 'https://github.com/dannyben/bashly'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'colsole', '>= 0.8.1', '< 2'
  s.add_runtime_dependency 'completely', '~> 0.6.1'
  s.add_runtime_dependency 'filewatcher', '~> 2.0'
  s.add_runtime_dependency 'gtx', '~> 0.1'
  s.add_runtime_dependency 'lp', '~> 0.2'
  s.add_runtime_dependency 'mister_bin', '~> 0.7'
  s.add_runtime_dependency 'requires', '~> 1.0'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/DannyBen/bashly/issues',
    'changelog_uri'         => 'https://github.com/DannyBen/bashly/blob/master/CHANGELOG.md',
    'homepage_uri'          => 'https://bashly.dannyb.co/',
    'source_code_uri'       => 'https://github.com/DannyBen/bashly',
    'rubygems_mfa_required' => 'true',
  }
end
