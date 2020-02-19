# frozen_string_literal: true

require_relative './spec_helper'

module Guanaco
  class BlockingExampleHandler < Guanaco.base_handler
    blocking true
    handling :get, 'blocking_example/:ms?:\d+'

    def execute
      wait = params.fetch('ms', '200').to_f / 1_000.0
      sleep wait
      {
        method: request.method_name,
        content_type: request.content_type,
        params: request.params,
        wait: wait
      }
    end
  end
end

RSpec.describe Guanaco::BlockingExampleHandler, :handlers do
  it { expect(described_class).to be_respond_to :handle }

  let(:req_headers) { { 'Content-Type' => json_type } }
  let(:req_params) { { a: 1 } }

  context 'mappings' do
    it { expect(Guanaco.handlers_registry.all.keys).to include 'blocking_example/:ms?:\\d+ : GET' }
  end

  let(:req_path) { '/blocking_example/250' }

  context 'GET example request' do
    let(:req_type) { :get }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1', ms: '250' },
                        wait: 0.25
    end
  end
end
