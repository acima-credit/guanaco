# frozen_string_literal: true

module Guanaco
  class Server
    class << self
      def run(host = nil, port = nil, loop = false)
        new(host, port, loop).run
      end

      def stage
        ENV['APP_STAGE'] || ENV['RACK_ENV'] || 'development'
      end
    end

    attr_reader :host, :port
    attr_accessor :loop

    def initialize(host = nil, port = nil, loop = false)
      @host    = host || ENV.fetch('HOST', '0.0.0.0')
      @port    = port || ENV.fetch('PORT', '3000').to_i
      @loop    = loop
      @started = false
    end

    def server
      @server ||= build_server
    end

    def run
      return if @started

      puts ">> starting at #{@host}:#{@port} ..."
      puts ">> and stage = #{self.class.stage} ..."
      server.start
      @started = true

      at_exit { shutdown }

      sleep 0.5 while loop

      self
    end

    def shutdown
      return unless @started

      server.stop
      @server  = nil
      @started = false
    end

    def development?
      self.class.stage == 'development'
    end

    def address
      INET_ADDRESS.getByName(@host)
    end

    def base_dir
      BASE_DIR.find
    end

    private

    def build_server
      RP_Server.of do |s|
        s.serverConfig(config)

        s.handlers { |chain| Handlers::Registry.apply_to(chain) }
      end
    end

    def config
      RP_ServerConfig.embedded.
        port(port).
        address(address).
        development(development?).
        base_dir(base_dir).
        props('application.properties')
    end
  end

  def self.build(host = nil, port = nil, loop = false)
    Server.new host, port, loop
  end

  def self.run(host = nil, port = nil, loop = false)
    Server.run host, port, loop
  end
end
