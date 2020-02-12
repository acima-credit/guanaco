# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Runner
        class << self
          def run(handler_class, ctx, body)
            instance = handler_class.new ctx, body
            execute_value = safe_execute instance
            if execute_value.is_a?(RP_Promise)
              execute_value.then { |value| process_value instance, value }
            else
              process_value instance, execute_value
            end
          end

        private

          # rubocop:disable Lint/RescueException
          def safe_execute(instance)
            instance.execute
          rescue Exception => e
            safe_execute_exception instance, e
          end
          # rubocop:enable Lint/RescueException

          def safe_execute_exception(instance, e)
            hsh = {
              status: 'error',
              message: 'There was an error processing your request',
              response_status: 500
            }
            return hsh unless instance.development?

            hsh[:message] += ": #{e.message}"
            hsh[:class]     = e.class
            hsh[:backtrace] = e.backtrace[0, 5]

            hsh
          end

          def process_value(instance, value)
            instance.send :measure, value
            result = build_result value
            instance.ctx.getResponse.tap do |response|
              response.
                status(result.status).
                send result.content_type, result.body
            end
          end

          def build_result(value)
            return value if value.is_a? HTTPResponse
            return HTTPResponse.json(value) if value.is_a? Hash

            HTTPResponse.plain value.to_s
          end
      end
      end
    end
  end
end
