# frozen_string_literal: true

require 'java'

require 'socket'
require 'securerandom'
require 'base64'
require 'forwardable'

require 'jruby/core_ext'
require 'jrjackson'

require_relative 'jars/guanaco_jars'

require_relative 'guanaco/version'
require_relative 'guanaco/constants'
require_relative 'guanaco/context_proxy'
require_relative 'guanaco/request_proxy'
require_relative 'guanaco/response_proxy'

require_relative 'guanaco/handlers/registry'
require_relative 'guanaco/handlers/base'
require_relative 'guanaco/handlers/default'
require_relative 'guanaco/handlers/status'

require_relative 'guanaco/config'
require_relative 'guanaco/server'
