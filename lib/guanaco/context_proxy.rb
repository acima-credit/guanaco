# frozen_string_literal: true

module Guanaco
  class Server
    class ContextProxy
      def initialize(original)
        @original = original
      end

      private

      def respond_to_missing?(name, include_private = false)
        @original.respond_to?(name, include_private)
      end

      def method_missing(method, *args, &block)
        @original.public_send(method, *args, &block)
      end
    end
  end
end
