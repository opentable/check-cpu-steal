lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/check_cpu_steal'

Gem::Specification.new do |s|
  s.authors               = ['Carl Flippin']
  s.date                  = Date.today.to_s
  s.description           = 'This plugin check cpu steal'
  s.email                 = 'carlf@photocarl.org'
  s.executables           = ['check_cpu_steal.rb']
  s.homepage              = 'https://github.com/opentable/check-cpu-steal'
  s.license               = 'MIT'
  s.name                  = 'check-cpu-steal'
  s.platform              = Gem::Platform::RUBY
  s.require_paths         = ['lib']
  s.required_ruby_version = '>= 2.0.0'
  s.summary               = 'A check for cpu steal'
  s.version               = CheckSteal::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'

  s.add_development_dependency 'rubocop', '~> 0.42.0'
  s.add_development_dependency 'rake',    '~> 11.2.2'
  s.add_development_dependency 'rspec',   '~> 3.5.0'
end
