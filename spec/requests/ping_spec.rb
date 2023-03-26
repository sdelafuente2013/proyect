require 'rails_helper'

describe 'Ping' do
  it 'responds with status ok' do

    get '/:esp/ping'

    expect(response.code).to eq('204')
  end
end
