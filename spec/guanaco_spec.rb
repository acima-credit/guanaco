# frozen_string_literal: true

RSpec.describe Guanaco do
  it 'has a version number' do
    expect(Guanaco::VERSION).not_to be nil
  end

  context 'registry keys' do
    let(:keys) do
      [
        'blocking_example/:ms?:\\d+ : GET',
        'example/delete : DELETE',
        'example/get : GET',
        'example/get_name/:name : GET',
        'example/get_rx/:rx?:\\d+ : GET',
        'example/get_token/:token? : GET',
        'example/patch : PATCH',
        'example/path : PATH',
        'example/post : POST',
        'example/put : PUT',
        'none : ALL',
        'status : GET'
      ]
    end
    it 'shows all' do
      # puts "Guanaco.handlers_registry.all.keys.sort | #{Guanaco.handlers_registry.all.keys.sort.inspect}"
      expect(Guanaco.handlers_registry.all.keys.sort).to eq keys
    end
  end
end
