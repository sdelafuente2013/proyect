require 'rails_helper'

describe 'Users AccessTypeTablets API', type: :request do
  options = { show: false, delete: false, check_attributes: ['descripcion'] }

  context 'for tolgeo ESP' do
    describe_crud(Esp::AccessTypeTablet, options)
  end

  context 'for tolgeo LATAM' do
    describe_crud(Latam::AccessTypeTablet, options.merge({factory: :access_type_tablet_latam}))
  end

  context 'for tolgeo MEX' do
    describe_crud(Mex::AccessTypeTablet, options.merge({factory: :access_type_tablet_mex}))
  end
end
