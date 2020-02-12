# frozen_string_literal: true

require_relative './spec_helper'

module Guanaco
  class ExampleHandler < Guanaco.base_handler
    handling :get, 'example/get'
    handling :post, 'example/post'
    handling :put, 'example/put'
    handling :patch, 'example/patch'
    handling :delete, 'example/delete'

    def execute
      {
        method: request_method,
        content_type: content_type,
        params: params
      }
    end
  end
end

RSpec.describe Guanaco::ExampleHandler, :handlers do
  it { expect(described_class).to be_respond_to :handle }
  it { expect(described_class.new).to be_respond_to :execute }

  let(:req_headers) { { 'Content-Type' => json_type } }
  let(:req_params) { { a: 1 } }

  context 'mappings' do
    it { expect(Guanaco.handlers_registry.keys).to include 'DELETE : example/delete' }
    it { expect(Guanaco.handlers_registry.keys).to include 'GET : example/get' }
    it { expect(Guanaco.handlers_registry.keys).to include 'PATCH : example/patch' }
    it { expect(Guanaco.handlers_registry.keys).to include 'POST : example/post' }
    it { expect(Guanaco.handlers_registry.keys).to include 'PUT : example/put' }
  end

  context 'registry keys' do
    let(:keys) do
      [
        'ALL : none',
        'DELETE : example/delete',
        'GET : example/get',
        'GET : status',
        'PATCH : example/patch',
        'POST : example/post',
        'PUT : example/put'
      ]
    end
    it { expect(Guanaco.handlers_registry.keys.sort).to eq keys }
  end

  let(:req_path) { "/example/#{req_type}" }

  context 'GET status request' do
    let(:req_type) { :get }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1' } }
  end

  context 'POST status request' do
    let(:req_type) { :post }
    it('works') { exp_json_response method: 'post', content_type: json_type, params: { a: '1' } }
  end

  context 'PUT status request' do
    let(:req_type) { :put }
    it('works') { exp_json_response method: 'put', content_type: json_type, params: { a: '1' } }
  end

  context 'PATCH status request' do
    let(:req_type) { :patch }
    it('works') { exp_json_response method: 'patch', content_type: json_type, params: { a: '1' } }
  end

  context 'DELETE status request' do
    let(:req_type) { :delete }
    it('works') { exp_json_response method: 'delete', content_type: json_type, params: { a: '1' } }
  end
end
