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
        params: request.params
      }
    end
  end
end

RSpec.describe Guanaco::ExampleHandler, :handlers do
  it { expect(described_class).to be_respond_to :handle }

  let(:req_headers) { { 'Content-Type' => json_type } }
  let(:req_params) { { a: 1 } }

  context 'mappings' do
    it { expect(Guanaco.handlers_registry.all.keys).to include 'DELETE : example/delete' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'GET : example/get' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'PATCH : example/patch' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'POST : example/post' }
    it { expect(Guanaco.handlers_registry.all.keys).to include 'PUT : example/put' }
  end

  context 'registry keys' do
    let(:keys) do
      [
        'ALL : none',
        'DELETE : example/delete',
        'GET : example/get',
        'GET : example/get_name/:name',
        'GET : example/get_rx/:rx?:\\d+',
        'GET : example/get_token/:token?',
        'GET : status',
        'PATCH : example/patch',
        'PATH : example/path',
        'POST : example/post',
        'PUT : example/put'
      ]
    end
    it { expect(Guanaco.handlers_registry.all.keys.sort).to eq keys }
  end

  let(:req_path) { "/example/#{req_type}" }

  context 'GET example request' do
    let(:req_type) { :get }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1' } }
  end

  context 'GET example token optional missing request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_token/' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1', token: '' } }
  end

  context 'GET example token optional present request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_token/tk' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1', token: 'tk' } }
  end

  context 'GET example name optional missing request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_name/' }
    it('works') { exp_json_response status: 'error', message: 'not found', response_status: 404 }
  end

  context 'GET example name optional present request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_name/john' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1', name: 'john' } }
  end

  context 'GET example rx optional missing request', :focus do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1' } }
  end

  context 'GET example rx optional valid request', :focus do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/10' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1', rx: '10' } }
  end

  context 'GET example rx optional invalid request', :focus do
    let(:req_type) { :get }
    let(:req_path) { '/example/get_rx/other' }
    it('works') { exp_json_response status: 'error', message: 'not found', response_status: 404 }
  end

  context 'POST example request' do
    let(:req_type) { :post }
    it('works') { exp_json_response method: 'post', content_type: json_type, params: { a: '1' } }
  end

  context 'PUT example request' do
    let(:req_type) { :put }
    it('works') { exp_json_response method: 'put', content_type: json_type, params: { a: '1' } }
  end

  context 'PATCH example request' do
    let(:req_type) { :patch }
    it('works') { exp_json_response method: 'patch', content_type: json_type, params: { a: '1' } }
  end

  context 'DELETE example request' do
    let(:req_type) { :delete }
    it('works') { exp_json_response method: 'delete', content_type: json_type, params: { a: '1' } }
  end

  context 'GET example path request' do
    let(:req_type) { :get }
    let(:req_path) { '/example/path' }
    it('works') { exp_json_response method: 'get', content_type: json_type, params: { a: '1' } }
  end

  context 'POST example path request' do
    let(:req_type) { :post }
    let(:req_path) { '/example/path' }
    it('works') { exp_json_response method: 'post', content_type: json_type, params: { a: '1' } }
  end

  context 'DELETE example path request' do
    let(:req_type) { :delete }
    let(:req_path) { '/example/path' }
    it('works') { exp_json_response method: 'delete', content_type: json_type, params: { a: '1' } }
  end
end
