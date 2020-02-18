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

    attr_reader :host, :port
    attr_accessor :loop

    def initialize(host = nil, port = nil, loop = false, options = {})
      @host    = host || ENV.fetch('HOST', '0.0.0.0')
      @port    = port || ENV.fetch('PORT', '3000').to_i
      @loop    = loop
      @options = options
      @started = false
    end

    def server
      @server ||= build_server
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

    def base_dir
      @base_dir ||= base_dir_from_options || found_basedir
    end

    def base_dir?
      !base_dir.nil?
    end

    def props_name
      options.fetch(:props_name, 'application.properties')
    end

    def base_path
      @base_path ||= Pathname.new base_dir.to_s
    end

    def props_path
      @props_path ||= base_path.join props_name
    end

    def props?
      props_path.file?
    end

    def public_name
      options.fetch(:public_name, 'public')
    end

    def public_path
      @public_path ||= base_path.join public_name
    end

    def public?
      public_path.directory?
    end

    def index_name
      options.fetch(:index_name, 'index.html')
    end

    private

    def build_server
      RP_Server.of do |s|
        s.serverConfig(config)
        s.handlers do |chain|
          Handlers::Registry.apply_to(chain)
          chain.files { |f| f.dir(public_path).indexFiles(index_name) } if public?
        end
      end
    end

    def config
      cfg = RP_ServerConfig.
            embedded.
            port(port).
            address(address).
            development(development?)
      if base_dir?
        cfg = cfg.base_dir(base_dir)
        cfg = cfg.props(props_name) if props?
      end
      cfg
    end

    def base_dir_from_options
      return false unless options[:base_dir]

      java.nio.file.FileSystems.get_default.get_path options[:base_dir].to_s
    end

    def found_basedir
      BASE_DIR.find
    rescue Java::JavaLang::IllegalStateException
      false
    end
  end

  def self.build(host = nil, port = nil, loop = false, options = {})
    Server.new host, port, loop, options
  end

  def self.run(host = nil, port = nil, loop = false, options = {})
    Server.run host, port, loop, options
  end
end
