# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Base
        class << self
          def handling(type, *args)
            args << self
            Registry.add type, *args
          end

          def handle(ctx)
            if ctx.getRequest.getMethod.isPost
              ctx.getRequest.getBody.then { |body| Runner.run self, ctx, body.getText }
            else
              Runner.run self, ctx, ''
            end
          end
        end

        attr_reader :ctx, :body

        def initialize(ctx = nil, body = nil)
          @ctx  = ctx
          @body = body
        end

        def remote_ip
          ctx.getRequest.getHeaders.get('X-Forwarded-For')
        end

        def params
          @params ||= ctx.getRequest.getQueryParams.to_h
        end

        def headers
          @headers ||= ctx.getRequest.getHeaders.getNames.each_with_object({}) do |name, hsh|
            hsh[name] = ctx.getRequest.getHeaders.get name
          end
        end

        def request_method
          ctx.getRequest.getMethod.getName.downcase.to_sym
        end

        def content_type
          ctx.getRequest.getHeaders.get 'Content-Type'
        end

        def measure(_result)
          # nothing to do here by default
        end

        def execute
          {}
        end

        def development?
          ctx.getServerConfig.isDevelopment
        end
      end
    end
  end

  def self.base_handler
    Server::Handlers::Base
  end
end
