# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Default < Base
        status 404
        content_type :json
        handling :all

        def execute
          {
            status: 'error',
            message: 'not found'
          }
        end
      end
    end
  end
end
