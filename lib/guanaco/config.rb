# frozen_string_literal: true

module Guanaco
  class Server
    class Options
      def self.build(server, options)
        new(server, options).build
      end

      attr_reader :server, :options

      def initialize(server, options)
        @server = server
        @options = options
      end

      def build_server
        RP_Server.of do |s|
          s.serverConfig server_config
          s.handlers do |chain|
            Handlers::Registry.apply_to(chain)
            chain_files chain
          end
        end
      end

      def server_config
        cfg = RP_ServerConfig.
              embedded.
              address(server.address).
              port(server.port).
              development(server.development?)
        if base_dir?
          cfg = cfg.base_dir(base_dir)
          cfg = cfg.props(props_name) if props?
        end
        cfg
      end

      def chain_files(chain)
        return unless public?

        chain.files { |f| f.dir(public_path).indexFiles(index_name) }
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
  end
end
