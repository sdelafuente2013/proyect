require 'rails_helper'

describe 'Groups AccessTypes API', type: :request do
  options = { show: false, delete: false, check_attributes: ['descripcion'] }

  context 'for tolgeo ESP' do
    describe_crud(Esp::AccessType, options)
  end

  context 'for tolgeo LATAM' do
    describe_crud(Latam::AccessType, options.merge({factory: :access_type_latam}))
  end

  context 'for tolgeo MEX' do
    describe_crud(Mex::AccessType, options.merge({factory: :access_type_mex}))
  end
end
