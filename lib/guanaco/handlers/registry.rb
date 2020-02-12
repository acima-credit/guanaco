# frozen_string_literal: true

module Guanaco
  class Server
    module Handlers
      class Registry
        class Entry
          def self.from(type, *args)
            if args.size == 1
              new type, nil, args.first
            else
              new type, args.first, args.last
            end
          end

          attr_reader :type, :url, :handler

          def initialize(type, url, handler)
            @type    = type
            @url     = url
            @handler = handler
          end

          def key
            format '%s : %s', type.to_s.upcase, url || 'none'
          end

          def delay?
            type == :all
          end

          def apply_to(chain)
            case type
            when :get
              chain.get url, handler
            when :post
              chain.post url, handler
            when :put
              chain.put url, handler
            when :patch
              chain.patch url, handler
            when :delete
              chain.delete url, handler
            when :all
              chain.all handler
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

          def keys
            all.keys
          end

          def values
            all.values
          end

          def each(&blk)
            values.each(&blk)
          end

          def select(&blk)
            values.select(&blk)
          end

          def reject(&blk)
            values.reject(&blk)
          end

          def add(type, *args)
            entry          = Entry.from type, *args
            all[entry.key] = entry
          end

          def apply_to(chain)
            reject(&:delay?).each { |entry| entry.apply_to chain }
            select(&:delay?).each { |entry| entry.apply_to chain }
          end
        end
      end
    end
  end

  def self.handlers_registry
    Server::Handlers::Registry
  end
end
