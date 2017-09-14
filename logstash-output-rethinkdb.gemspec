# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'logstash-output-rethinkdb'
  s.version       = '0.1.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Write a short summary, because Rubygems requires one.'
  s.description   = 'Write a longer description or delete this line.'
  s.homepage      = 'http://example.com/'
  s.authors       = ['Dane Jensen']
  s.email         = 'djensen@apericorp.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*',
                'spec/**/*',
                'vendor/**/*',
                '*.gemspec',
                '*.md',
                'CONTRIBUTORS',
                'Gemfile',
                'LICENSE',
                'NOTICE.TXT'
  ]
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { 'logstash_plugin' => 'true', 'logstash_group' => 'output' }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', '~> 2.0'

  # for bufffering
  # s.add_runtime_dependency 'stud'

  s.add_runtime_dependency 'rethinkdb', '~> 2.3'

  s.add_development_dependency 'logstash-codec-json'
  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'logstash-input-generator'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  # s.add_development_dependency 'flores'
end
