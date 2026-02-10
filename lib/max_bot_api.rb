# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'json'

require_relative 'max_bot_api/version'
require_relative 'max_bot_api/errors'
require_relative 'max_bot_api/client'

require_relative 'max_bot_api/builders/message_builder'
require_relative 'max_bot_api/builders/keyboard_builder'

require_relative 'max_bot_api/updates/parser'

require_relative 'max_bot_api/resources/bots'
require_relative 'max_bot_api/resources/chats'
require_relative 'max_bot_api/resources/messages'
require_relative 'max_bot_api/resources/subscriptions'
require_relative 'max_bot_api/resources/uploads'
require_relative 'max_bot_api/resources/debugs'
