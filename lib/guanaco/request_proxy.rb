# frozen_string_literal: true

module Guanaco
  class Server
    class RequestProxy
      def initialize(context)
        @context = context
        @request = context.get_request
        @body = :uninitialized
      end

      def body
        return @body unless @body == :uninitialized

        @body = @request.get_body.then { |str| @body = str }
        sleep 0.01 while @body == :uninitialized
        @body
      end

      def method_name
        @method_name ||= @request.get_method.get_name.downcase
      end

      %i[delete get head options patch post put].each do |name|
        define_method("#{name}?") { method_name == name.to_s }
      end

      def headers
        @headers ||= build_headers
      end

      def content_type
        headers['Content-Type']
      end

      def remote_ip
        headers['X-Forwarded-For']
      end

      def params
        @params ||= build_params
      end

      def remote_address
        @request.remote_address.to_s
      end

      def host
        @request.remote_address.host_text
      end

      def port
        @request.remote_address.port
      end

      def scheme
        @protocol.split('/').first.downcase
      end

      def to_s
        "#<#{self.class.name} " \
          "path=#{path.inspect} " \
          "query=#{query.inspect} " \
          "params=#{params.inspect} " \
          "headers=#{headers.inspect}>"
      end

      alias inspect to_s

      private

      def method_missing(method, *args, &block)
        @request.send(method, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        @request.respond_to? method_name, include_private
      end

      def build_headers
        @request.get_headers.get_names.each_with_object({}) do |name, hsh|
          hsh[name] = @context.get_request.get_headers.get name
        end
      end

      def build_params
        params_from_query.update params_from_tokens
      end

      def params_from_query
        @request.query_params.to_h
      end

      def params_from_tokens
        @context.get_path_tokens.key_set.each_with_object({}) do |name, hsh|
          hsh[name] = @context.get_path_tokens.get name
        end
      end
    end
  end
end
