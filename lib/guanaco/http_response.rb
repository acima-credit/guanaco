# frozen_string_literal: true

module Guanaco
  class Server
    class HTTPResponse
      JSON_TYPE = 'application/json;charset=UTF-8'
      PLAIN_TYPE = 'text/plain;charset=UTF-8'

      # @param [Hash{Symbol,String->Object}] object
      def self.json(object = {})
        status = object.delete(:response_status) || 200
        headers = object.delete(:response_headers) || {}
        headers['Content-Type'] = JSON_TYPE
        new status, headers, JrJackson::Json.dump(object)
      end

      def self.plain(str = '', status = 200, headers = {})
        headers['Content-Type'] ||= PLAIN_TYPE
        new status, headers, str
      end

      attr_accessor :status, :headers, :body

      def initialize(status, headers, body)
        @status = status
        @headers = headers
        @body = body
      end

      def content_type
        headers['Content-Type']
      end

      def to_ary
        [status, headers, body]
      end

      def to_s
        to_ary.inspect
      end

      alias inspect to_s
    end
  end
end
