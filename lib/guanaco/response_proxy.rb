# frozen_string_literal: true

module Guanaco
  class Server
    class ResponseProxy
      def initialize(response)
        @response = response
      end

      def set_headers(new_headers = {})
        new_headers.each do |k, v|
          k = k.to_s.split('_').map(&:capitalize).join('-') if k.is_a?(Symbol)
          @response.headers.set k.to_s, v.to_s
        end
        self
      end

      def send_body(body)
        @response.send body
        self
      end

      def to_s
        "#<#{self.class.name} " \
          "status=#{@response.get_status} " \
          "headers=#{headers.inspect}>"
      end

      alias inspect to_s

      private

      def method_missing(method, *args, &block)
        @response.send(method, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        @response.respond_to? method_name, include_private
      end
    end
  end
end
