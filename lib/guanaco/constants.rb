# frozen_string_literal: true

module Guanaco
  class Server
    RP_Server = Java::RatpackServer::RatpackServer # ratpack.server.RatpackServer
    RP_Blocking = Java::RatpackExec::Blocking # ratpack.exec.Blocking
    RP_Promise = Java::RatpackExec::Promise # ratpack.exec.Promise
    RP_Streams = Java::RatpackStream::Streams # ratpack.stream.Streams
    RP_ResponseChunks = Java::RatpackHttp::ResponseChunks # ratpack.http.ResponseChunks
    RP_ServerConfig = Java::RatpackServer::ServerConfig # ratpack.server.ServerConfig

    DURATION = Java::JavaTime::Duration # java.time.Duration
    CHARSET = Java::JavaNioCharset::Charset # java.nio.charset.Charset
    INET_ADDRESS = Java::JavaNet::InetAddress # java.net.InetAddress
    BASE_DIR = Java::RatpackServer::BaseDir # ratpack.server.BaseDir
  end
end
