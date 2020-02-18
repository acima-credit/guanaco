# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Status < Base
        content_type :json
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
