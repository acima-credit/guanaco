# frozen_string_literal: true

require_relative './spec_helper'

module Guanaco
  class ExampleHandler < Guanaco.base_handler
    handling :delete, 'example/delete'
    handling :get, 'example/get'
    handling :get, 'example/get_name/:name'
    handling :get, 'example/get_rx/:rx?:\d+'
    handling :get, 'example/get_token/:token?'
    handling :patch, 'example/patch'
    handling :path, 'example/path'
    handling :post, 'example/post'
    handling :put, 'example/put'

    def execute
      {
        method: request.method_name,
        content_type: request.content_type,
        params: request.params,
        body: body
      }
    end
  end
end

RSpec.describe Guanaco::ExampleHandler, :handlers do
  it { expect(described_class).to be_respond_to :handle }

  let(:req_headers) { { 'Content-Type' => json_type } }
  let(:req_params) { { a: 1 } }

  context 'mappings' do
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/delete : DELETE' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/get : GET' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/get_name/:name : GET' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/get_rx/:rx?:\\d+ : GET' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/get_token/:token? : GET' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/patch : PATCH' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/path : PATH' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/post : POST' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'example/put : PUT' }
  end

  let(:req_path) { "/example/#{req_type}" }

  context 'GET example request' do
    let(:req_type) { :get }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end

  context 'GET example token optional missing request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_token/' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1', token: '' },
                        body: ''
    end
  end

  context 'GET example token optional present request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_token/tk' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1', token: 'tk' },
                        body: ''
    end
  end

  context 'GET example name optional missing request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_name/' }
    it('works') do
      exp_json_response status: 'error',
                        message: 'not found',
                        response_status: 404
    end
  end

  context 'GET example name optional present request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_name/john' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1', name: 'john' },
                        body: ''
    end
  end

  context 'GET example rx optional missing request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end

  context 'GET example rx optional valid request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/10' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1', rx: '10' },
                        body: ''
    end
  end

  context 'GET example rx optional invalid request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/other' }
    it('works') do
      exp_json_response status: 'error',
                        message: 'not found',
                        response_status: 404
    end
  end

  context 'POST example request' do
    let(:req_type) { :post }
    let(:req_body) { '{"b":2}' }
    it('works') do
      exp_json_response method: 'post',
                        content_type: json_type,
                        params: { a: '1' },
                        body: '{"b":2}'
    end
  end

  context 'PUT example request' do
    let(:req_type) { :put }
    let(:req_body) { '{"b":2}' }
    it('works') do
      exp_json_response method: 'put',
                        content_type: json_type,
                        params: { a: '1' },
                        body: '{"b":2}'
    end
  end

  context 'PATCH example request' do
    let(:req_type) { :patch }
    let(:req_body) { '{"b":2}' }
    it('works') do
      exp_json_response method: 'patch',
                        content_type: json_type,
                        params: { a: '1' },
                        body: '{"b":2}'
    end
  end

  context 'DELETE example request' do
    let(:req_type) { :delete }
    it('works') do
      exp_json_response method: 'delete',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end

  context 'GET example path request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/path' }
    it('works') do
      exp_json_response method: 'get',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end

  context 'POST example path request' do
    let(:req_type) { :post }
    let(:req_path) { '/example/path' }
    it('works') do
      exp_json_response method: 'post',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end

  context 'DELETE example path request' do
    let(:req_type) { :delete }
    let(:req_path) { '/example/path' }
    it('works') do
      exp_json_response method: 'delete',
                        content_type: json_type,
                        params: { a: '1' },
                        body: ''
    end
  end
end
