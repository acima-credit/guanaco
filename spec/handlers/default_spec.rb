# frozen_string_literal: true

require_relative './spec_helper'

RSpec.describe Guanaco::Server::Handlers::Default, :handlers do
  it { expect(described_class).to be_respond_to :handle }

  let(:exp_hsh) do
    {
      status: 'error',
      message: 'not found',
      response_status: 404
    }
  end

  context 'empty GET root request' do
    let(:req_path) { '/' }
    it { exp_json_response exp_hsh }
  end
  context 'full POST root request' do
    let(:req_type) { :post }
    let(:req_path) { '/a/b' }
    let(:req_params) { { a: 1, b: 2 } }
    let(:req_body) { json_conv c: 3, d: 4 }
    it { exp_json_response exp_hsh }
  end
end
