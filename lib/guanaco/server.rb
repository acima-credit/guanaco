# frozen_string_literal: true

module Guanaco
  class Server
    class << self
      def run(host = nil, port = nil, loop = false, options = {})
        new(host, port, loop, options).run
      end

      def stage
        ENV['APP_STAGE'] || ENV['RACK_ENV'] || 'development'
      end
    end

    attr_reader :host, :port, :options, :config
    attr_accessor :loop

    def initialize(host = nil, port = nil, loop = false, options = {})
      @host = host || ENV.fetch('HOST', '0.0.0.0')
      @port = port || ENV.fetch('PORT', '3000').to_i
      @loop = loop
      @options = options
      @config = Config.build options
      @started = false
    end

    def server
      @server ||= config.build_server
    end

    def banner
      puts ">> starting at #{@host}:#{@port} ..."
      puts ">> and stage = #{self.class.stage} ..."
    end

    def run
      return if @started

      banner
      server.start
      @started = true

      at_exit { shutdown }
      Signal.trap('INT') { shutdown }
      Signal.trap('TERM') { shutdown }

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
  end

  def self.build(host = nil, port = nil, loop = false, options = {})
    Server.new host, port, loop, options
  end

  def self.run(host = nil, port = nil, loop = false, options = {})
    Server.run host, port, loop, options
  end
end
