# frozen_string_literal: true

require 'ostruct'
require 'rspec'
require 'rspec/core/shared_context'

module Guanaco
  module HandlerHelpers
    RP_EmbeddedApp = Java::RatpackTestEmbed::EmbeddedApp # ratpack.test.embed.EmbeddedApp
    RP_ExecHarness = Java::RatpackTestExec::ExecHarness # ratpack.test.exec.ExecHarness

    extend RSpec::Core::SharedContext

    let(:server) { RP_EmbeddedApp.fromHandlers { |chain| Guanaco.handlers_registry.apply_to chain } }

    extend RSpec::Core::SharedContext

    let(:json_type) { Guanaco::Server::HTTPResponse::JSON_TYPE }
    let(:pain_type) { Guanaco::Server::HTTPResponse::PLAIN_TYPE }

    let(:send_message_stub) { nil }
    let(:send_message_args) { nil }

    let(:send_messages_stub) { nil }
    let(:send_messages_args) { nil }

    let(:poll_stub) { nil }
    let(:poll_args) { nil }

    let(:req_type) { :get }
    let(:req_path) { '/' }
    let(:req_params) { {} }
    let(:req_headers) { {} }
    let(:req_body) { nil }
    let(:other_reqs) { [] }

    let(:response) { @response }
    let(:act_body) { response.getBody.getText }
    let(:act_content_type) { response.getBody.getContentType.getType }
    let(:act_status_code) { response.getStatusCode }

    def exp_json_response(hsh = {})
      run_request

      exp_content_type = 'application/json'
      type_msg         = "expected content_type to be [#{exp_content_type}]\n" \
                       "                    but was [#{act_content_type}]"
      expect(act_content_type).to eq(exp_content_type), type_msg

      exp_status = hsh.delete(:response_status) || 200
      stat_msg   = "expected status to be [#{exp_status}]\n" \
                 "              but was [#{act_status_code}]"
      expect(act_status_code).to eq(exp_status), stat_msg

      exp_body = JrJackson::Json.dump hsh
      body_msg = "expected body to be [#{exp_body}]\n" \
               "            but was [#{act_body}]"
      expect(act_body).to eq(exp_body), body_msg
    end

    def exp_plain_response(exp_body = '', hsh = {})
      run_request

      exp_content_type = 'text/plain'
      type_msg         = "expected content_type to be [#{exp_content_type}]\n                    but was [#{act_content_type}]"
      expect(act_content_type).to eq(exp_content_type), type_msg

      exp_status = hsh.delete(:response_status) || 200
      stat_msg   = "expected status to be [#{exp_status}]\n              but was [#{act_status_code}]"
      expect(act_status_code).to eq(exp_status), stat_msg

      body_msg = "expected body to be [#{exp_body}]\n            but was [#{act_body}]"
      expect(act_body).to eq(exp_body), body_msg
    end

    def run_request
      req_url = req_path
      req_url += '?' + req_params.to_query unless req_params.empty?

      server.test do |client|
        other_reqs.each do |args|
          qty = args[0]
          url = args[1]
          meth = (args[2] || :get).to_s.upcase
          qty.times do
            client.request(url) { |req| req.method meth }
          end
        end
        @response = client.request(req_url) do |req_spec|
          req_spec.getBody.text(req_body) if req_body
          # req_headers&.each { |k, v| req_spec.getHeaders.set k.to_s, v.to_s }
          req_headers&.each do |k, v|
            hsh1 = req_spec.getHeaders.getNames.each_with_object({}) { |name, hsh| hsh[name] = req_spec.getHeaders.get name }
            puts "> hdrs : 0 : #{k.inspect} = #{v.inspect}"
            puts "> hdrs : 1 : (#{req_spec.getHeaders.class.name}) #{hsh1.inspect}"
            req_spec.getHeaders.set k.to_s, v.to_s
            hsh2 = req_spec.getHeaders.getNames.each_with_object({}) { |name, hsh| hsh[name] = req_spec.getHeaders.get name }
            puts "> hdrs : 2 : (#{req_spec.getHeaders.class.name}) #{hsh2.inspect}"
          end
          req_spec.method req_type.to_s.upcase
        end
      end
    end

    def json_conv(hsh = {})
      JrJackson::Json.dump hsh
    end
  end
end

RSpec.configure do |config|
  config.include Guanaco::HandlerHelpers, :handlers
end
