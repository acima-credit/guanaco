# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Registry
        class Entry
          def self.build(type, path = nil, handler = nil)
            new type, path, handler
          end

          attr_reader :type, :path, :handler

          def initialize(type, path = nil, handler = nil)
            @type = type
            @path = path
            @handler = handler || Handlers::Default
          end

          def key
            format '%s : %s', path || 'none', type.to_s.upcase
          end

          def delay?
            type == :all
          end

          def apply_to(chain)
            if path.nil?
              chain.send type, handler
            else
              chain.send type, path, handler
            end
          end

          def to_s
            format '#<%s type=%s url=%s handler=%s>', self.class.name, type.inspect, url.inspect, handler.name
          end

          alias inspect to_s
        end

        class << self
          def all
            @all ||= {}
          end

          def add(type, path = nil, handler = nil)
            entry = Entry.build type, path, handler
            all[entry.key] = entry
          end

          def apply_to(chain)
            all.values.reject(&:delay?).each { |entry| entry.apply_to chain }
            all.values.select(&:delay?).each { |entry| entry.apply_to chain }
            chain
          end
        end
      end
    end
  end

  def self.handlers_registry
    Server::Handlers::Registry
  end
end
