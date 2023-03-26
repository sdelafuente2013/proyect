require_relative '../../app/lib/foros_client'
require 'rails_helper'

describe 'Foros::Client' do
  it 'adds to model connection error if cannot connect to foros' do
    allow(RestClient).to receive(:get).and_raise(RestClient::Exception)
    test_model = TestModel.new

    test_model.ping_foro

    expect(test_model.errores.last).to eq("connection refused foros")
  end

  it 'does not add to the model connection error for service unavailable' do
    stub_request(:get, "http://localhost:3001/").to_return(status: [503, 'Service Unavailable'])
    test_model = TestModel.new

    test_model.ping_foro
    expect(test_model.errores).to eq(["FOROS ERROR "])
  end

  class TestModel
    include ::Foros::Client

    def initialize
      @errores = []
    end

    def valid?
      true
    end

    def ping_foro
      send_request('ping')
    end

    def errores=(error)
      @errores = error
    end

    def errores
      @errores
    end
  end
end
