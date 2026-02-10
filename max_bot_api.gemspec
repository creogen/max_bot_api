# frozen_string_literal: true

require_relative 'lib/max_bot_api/version'

Gem::Specification.new do |spec|
  spec.name = 'max_bot_api'
  spec.version = MaxBotApi::VERSION
  spec.authors = ['ChatGPT Codex', 'Dmitry Merkushin']
  spec.email = ['merkushin@hey.com']

  spec.summary = 'Ruby client for MAX Bot API'
  spec.description = 'Ruby gem that mirrors the MAX Bot API Go client.'
  spec.homepage = 'https://github.com/creogen/max_bot_api'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir['lib/**/*', 'README.md', 'docs/**/*', 'examples/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'base64', '~> 0.1'
  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'faraday-multipart', '~> 1.0'

  spec.add_development_dependency 'minitest', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.18'

  spec.metadata['homepage_uri'] = 'https://github.com/creogen/max_bot_api'
  spec.metadata['source_code_uri'] = 'https://github.com/creogen/max_bot_api/tree/main'
end
