# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Status < Base
        handling :get, 'status'

        def execute
          {
            status: 'ok'
          }
        end
      end
    end
  end
end
