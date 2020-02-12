# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Default < Base
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
