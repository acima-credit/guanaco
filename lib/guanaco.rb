# frozen_string_literal: true

require 'java'

require 'socket'
require 'securerandom'
require 'base64'

require 'jruby/core_ext'
require 'jrjackson'

require_relative 'jars/guanaco_jars'

require_relative 'guanaco/version'
require_relative 'guanaco/constants'
require_relative 'guanaco/http_response'

require_relative 'guanaco/handlers/registry'
require_relative 'guanaco/handlers/runner'
require_relative 'guanaco/handlers/base'
require_relative 'guanaco/handlers/default'
require_relative 'guanaco/handlers/status'

require_relative 'guanaco/server'

module Guanaco
  class Error < StandardError; end
end
