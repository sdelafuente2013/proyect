# frozen_string_literal: true

# rubocop:disable RSpec/HookArgument
# rubocop:disable RSpec/ExampleLength

require 'rails_helper'

describe 'Foro', wip: true do
  subject do
    Esp::Foro.new(params)
  end

  shared_examples 'success action' do
    it 'is truthy' do
      expect(subject.send(action)).to be_truthy
    end

    it "has't errors" do
      subject.send(action)

      expect(subject.errors.full_messages).to be_empty
    end
  end

  shared_examples 'fails action' do
    it 'is falsey' do
      expect(subject.send(action)).to be_falsey
    end

    it 'includes errors' do
      subject.send(action)

      expect(subject.errors.full_messages).to eq(expected_errors)
    end
  end

  shared_examples 'builds correct url' do
    it 'builds url' do
      subject.send(action)

      url = subject.build_uri_for(endpoint_action.to_s)

      expect(url).to eq(expected_url)
    end
  end

  before(:each) do
    stub_requests
    create_subsystem
  end

  describe 'calls ping request' do
    let(:params) { empty_params }
    let(:action) { :ping }
    let(:endpoint_action) { :ping }
    let(:expected_url) { base_url }

    it 'is truthy' do
      expect(subject).to be_truthy
    end

    include_examples 'builds correct url'
  end

  describe 'is created' do
    let(:action) { :create }
    let(:endpoint_action) { :create }

    context 'with empty params' do
      let(:params) { empty_params }
      let(:expected_errors) { error_list }

      include_examples 'fails action'
    end

    context 'with valid params' do
      let(:params) { valid_params }
      let(:expected_url) { valid_uri_created }

      include_examples 'success action'
      include_examples 'builds correct url'
    end
  end

  describe 'is destroyed' do
    context 'with empty params' do
      let(:params) { empty_params }

      it 'is falsey' do
        expect(subject.destroy).to be_falsey
      end

      it 'has username error' do
        subject.destroy

        errors = subject.errors.full_messages

        expect(errors).to eq(['user_name is required'])
      end
    end

    context 'with valid username' do
      let(:params) { { user_name: valid_user_name } }
      let(:action) { :destroy }
      let(:endpoint_action) { :destroy }
      let(:expected_url) { valid_uri_destroy }

      include_examples 'success action'
      include_examples 'builds correct url'
    end
  end

  describe 'is updated' do
    let(:action) { :update }
    let(:endpoint_action) { :update }

    context 'with empty params' do
      let(:params) { empty_params }
      let(:expected_errors) { ['user_name is required'] }

      include_examples 'fails action'
    end

    context 'with username and password' do
      let(:params) { { user_name: valid_user_name, user_pass: valid_password } }
      let(:expected_url) { "#{valid_uri_update}&user_pass=molamazo" }

      include_examples 'builds correct url'
    end

    context 'with email and username' do
      let(:params) { { user_name: valid_user_name, user_email: new_email } }
      let(:expected_url) { "#{valid_uri_update}&user_email=#{new_email}" }

      include_examples 'builds correct url'
    end

    context 'with new username' do
      new_username = 'TOL13'
      let(:params) { { user_name: valid_user_name, new_user_name: new_username } }
      let(:expected_url) { "#{valid_uri_update}&new_user_name=#{new_username}" }

      include_examples 'builds correct url'
    end

    context 'with username, password, email' do
      new_password = 'molamazo2'
      let(:params) do
        { user_name: valid_user_name, user_pass: new_password, user_email: new_email }
      end
      let(:expected_url) { "#{valid_uri_update}&user_email=#{new_email}&user_pass=#{new_password}" }

      include_examples 'builds correct url'
    end
  end

  describe 'Group' do
    subject do
      Esp::GroupForo.new(params)
    end

    describe 'is created' do
      let(:action) { :create }
      let(:endpoint_action) { :create_group }

      context 'with empty params', wip2: true do
        let(:params) { empty_params }
        let(:expected_errors) { ['user_group is required', 'permis is required'] }

        include_examples 'fails action'
      end

      context 'with valid params', wip3: true do
        let(:params) { valid_group_params }
        let(:expected_url) { valid_group_uri_created }

        before(:each) do
          @foro_group = Esp::GroupForo.new(valid_group_params)
        end

        include_examples 'success action'
        include_examples 'builds correct url'
      end
    end

    describe 'is updated' do
      let(:action) { :update }
      let(:endpoint_action) { :update_group }

      context 'with empty params' do
        let(:params) { empty_params }
        let(:expected_errors) { ['group_name is required'] }

        include_examples 'fails action'
      end

      context 'with new group name' do
        let(:params) do
          {
            group_name: valid_user_group,
            new_group_name: valid_password
          }
        end
        let(:expected_url) { "#{valid_group_uri_update}&new_group_name=molamazo" }

        include_examples 'success action'
        include_examples 'builds correct url'
      end
    end

    describe 'is deleted' do
      let(:action) { :destroy }
      let(:endpoint_action) { :destroy_group }
      let(:expected_errors) { ['user_group is required'] }

      context 'with empty params' do
        let(:params) { empty_params }

        include_examples 'fails action'
      end

      context 'with valid user group' do
        let(:params) { { user_group: valid_user_group } }
        let(:expected_url) { valid_group_uri_destroy }

        include_examples 'success action'
        include_examples 'builds correct url'
      end

      context 'with user group and disabled' do
        let(:params) { { user_group: valid_user_group, disable_users: 1 } }
        let(:expected_url) { "#{valid_group_uri_destroy}&disable_users=1" }

        include_examples 'builds correct url'
      end
    end

    describe 'is moved' do
      let(:action) { :move }
      let(:endpoint_action) { :move_group }

      context 'with empty params' do
        let(:params) { empty_params }
        let(:expected_errors) do
          [
            'user_group is required',
            'user_groups is required',
            'user_style is required'
          ]
        end

        include_examples 'fails action'
      end

      context 'with valid user group, user groups, user style' do
        let(:params) do
          {
            user_group: valid_user_group,
            user_groups: valid_user_groups,
            user_style: valid_user_style
          }
        end
        let(:expected_url) do
          "#{valid_group_uri_move}" \
            "&user_group=#{valid_user_group}" \
            "&user_groups=#{valid_user_groups}" \
            "&user_style=#{valid_user_style}"
        end

        include_examples 'success action'
        include_examples 'builds correct url'
      end
    end
  end

  describe 'TolUser is created' do
    context 'when API Foros is unreachable' do
      before(:each) do
        do_api_foros_unreachable
        prepare_requests
        @user = create_tol_user_with_consultoria_and_collective
      end

      it 'has errors' do
        begin
          @user.save
        rescue UncaughtThrowError
        end

        errors = @user.errors.full_messages

        expect(errors).to eq(['connection refused foros'])
      end
    end

    it 'TolUser is created with consultoria and collective, it builds a valid url for foros' do
      user = create_tol_user_with_consultoria_and_collective
      valid_url_for_foros = valid_uri_base % [base_url, 'crea_grupo.php', 'user_group=C%s&permis=ctol' % user.username]
      foro = user.send('foro_to_create')

      url = foro.build_uri_for('create_group')

      expect(url).to eq(valid_url_for_foros)
    end

    it 'TolUser is created with consultoria and without collective, it builds a valid url for foros' do
      valid_url_for_foros = valid_uri_base % [base_url, 'crea_usuario.php', 'user_name=CTOLtonetti&user_email=sorianodepus@tirant.com&user_pass=sorianodepus&user_groups=ctol&user_style=ctol']
      user = create_tol_user_with_consultoria_and_without_collective
      foro = user.send('foro_to_create')

      url = foro.build_uri_for('create')

      expect(url).to eq(valid_url_for_foros)
    end

    it "TolUser is created with collective and without consultoria, it doesn't retrive a foro" do
      user = create_tol_user_with_collective_and_without_consultoria

      foro = user.send('foro_to_create')

      expect(foro).to be_nil
    end

    it "TolUser is created without consultoria and collective, it doesn't retrieve foro" do
      user = create_tol_user_without_consultoria_and_collective

      foro = user.send('foro_to_create')

      expect(foro).to be_nil
    end
  end

  it 'TolUser is destroyed with consultoria and collective, it builds a valid url for foros' do
    user = create_tol_user_with_consultoria_and_collective
    valid_url_for_foros = valid_uri_base % [base_url, 'borra_grupo.php', 'user_group=C%s&disable_users=1' % user.username]
    foro = user.send('foro_to_destroy')

    url = foro.build_uri_for('destroy_group')

    expect(url).to eq(valid_url_for_foros)
  end

  it 'TolUser is destroyed with consultoria and without collective, it builds a valid url for destroy in foros' do
    user = create_tol_user_with_consultoria_and_without_collective
    valid_url_for_foros = valid_uri_base % [base_url, 'borra_usuario.php', 'user_name=CTOL%s' % user.username]
    foro = user.send(:foro_to_destroy)

    url = foro.build_uri_for('destroy')

    expect(url).to eq(valid_url_for_foros)
  end

  it "TolUser is destroyed with collective and without consultoria, it doesn't retrieve foro" do
    user = create_tol_user_with_collective_and_without_consultoria

    foro = user.send(:foro_to_destroy)

    expect(foro).to be_nil
  end

  it "TolUser is destroyed without consultoria and collective, it doesn't retrieve foro" do
    user = create_tol_user_without_consultoria_and_collective

    foro = user.send(:foro_to_destroy)

    expect(foro).to be_nil
  end

  describe 'When valid user is modified' do
    context 'Changes TolUser with consultoria and without collective to TolUser without Consultoria' do
      it 'builds a valid url for modify in foros' do
        user = create_tol_user_without_consultoria_and_collective
        user.has_consultoria_before = false
        consultoria = create(:modulo, id: 4)
        user.update(modulos: [consultoria])
        url_for_modify_in_foros = valid_uri_base % [base_url, 'borra_usuario.php', 'user_name=CTOLtonetti']
        foro = user.send(:foro_to_update).first[:foro]

        url = foro.build_uri_for('destroy')

        expect(url).to eq(url_for_modify_in_foros)
      end
    end

    context 'TolUser with consultoria and non-collective changes to consultoria and collective' do
      before (:each) do
        @user = create(:user, modulo_ids: [create_modulo_consultoria.id], iscolectivo: false, subid: 0, username: 'tonetti')
        @user.has_consultoria_before = true
        @user.iscolectivo=true
        @user_subscription_1 =  create(:user_subscription_with_fake_password, :user => @user)
        @user_subscription_2 =  create(:user_subscription_with_fake_password, :user => @user)
        @user.save
        @foro = @user.send('foro_to_update')
      end

      it 'builds a valid foro url for destroy ctol user' do
        url_foros = valid_uri_base % [base_url, 'borra_usuario.php', 'user_name=CTOLtonetti']

        foro = @foro[0][:foro]

        expect(foro.build_uri_for('destroy')).to eq(url_foros)
      end

      it 'builds a valid foro url for create a group with ctol permits' do
        url_foros = valid_uri_base % [base_url, 'crea_grupo.php', 'user_group=Ctonetti&permis=ctol']

        foro = @foro[1][:foro]

        expect(foro.build_uri_for('create_group')).to eq(url_foros)
      end

      it 'builds a valid foro urls for add all the foros personalization users to the new group' do
        @user.user_subscriptions.each_with_index do |us,i|
          url_partial = <<~URL.squish.delete(' ')
            user_name=TOL#{us.id}&
            user_email=#{us.perusuid}&
            user_pass=#{Esp::User::FAKE_SECRET}&
            user_groups=C#{@user.username}&
            user_style=ctol
          URL

          url_foros = valid_uri_base % [base_url, 'crea_usuario.php', url_partial]

          expect(@foro[2 + i][:foro].build_uri_for('create')).to eq(url_foros)
        end
      end
    end

    context 'TolUser with consultoria and collective changes to non-consultoria' do
      before (:each) do
        @user = create(:user, modulo_ids: [create_modulo_consultoria.id], iscolectivo: true, subid: 0, username: 'tonetti')
        @user.has_consultoria_before = true
        @user.modulo_ids = []
        @user.save
      end

      it "builds a valid foro url for move all group's users the old group to the new one" do
        url_foros = valid_uri_base % [base_url, 'grupo_mueve_a_grupos.php', 'user_group=Ctonetti&user_groups=tol&user_style=ctol']

        foro = @user.send(:foro_to_update).first[:foro]

        expect(foro.build_uri_for('move_group')).to eq(url_foros)
      end

      it 'builds a valid foro url for destroy the old group' do
        url_foros = valid_uri_base % [base_url, 'borra_grupo.php', 'user_group=Ctonetti']

        foro = @user.send(:foro_to_update).last[:foro]

        expect(foro.build_uri_for('destroy_group')).to eq(url_foros)
      end
    end

    context 'TolUser with consultoria and collective changes to non-collective' do
      before (:each) do
        @user = create(
          :user,
          modulo_ids: [create_modulo_consultoria.id],
          iscolectivo: true,
          subid: 0, username: 'tonetti'
        )
        @user.has_consultoria_before = true
        @user.iscolectivo = false
      end

      it "builds a valid foro url for move all group's users the old group to the new one" do
        url_foros = valid_uri_base % [base_url, 'grupo_mueve_a_grupos.php', 'user_group=Ctonetti&user_groups=tol&user_style=ctol']

        foro = @user.send('foro_to_update').first[:foro]

        expect(foro.build_uri_for('move_group')).to eq(url_foros)
      end

      it 'builds a valid foro url for destroy the old group' do
        url_foros = valid_uri_base % [base_url, 'borra_grupo.php', 'user_group=Ctonetti']

        foro = @user.send('foro_to_update')[1][:foro]

        expect(foro.build_uri_for('destroy_group')).to eq(url_foros)
      end

      it 'builds a valid foro url for create a new user with permits and style ctol' do
        url_foros = valid_uri_base % [base_url, 'crea_usuario.php', 'user_name=CTOLtonetti&user_email=%s&user_pass=%s&user_groups=ctol&user_style=ctol' % [@user.email, @user.password]]

        foro = @user.send(:foro_to_update)[2][:foro]

        expect(foro.build_uri_for('create')).to eq(url_foros)
      end
    end


    it 'TolUser without consultoria changes to have consultoria and non-collective, it builds a valid foro url for create a a user with permits and style ctol' do
      user = create(:user, iscolectivo: true, subid: 0, username: 'tonetti')
      user.has_consultoria_before = false
      user.modulo_ids = [create_modulo_consultoria.id]
      url_foros = valid_uri_base % [base_url, 'crea_usuario.php', 'user_name=CTOLtonetti&user_email=%s&user_pass=%s&user_groups=ctol&user_style=ctol' % [user.email, user.password]]
      user.iscolectivo = false

      foro = user.send(:foro_to_update).first[:foro]

      expect(foro.build_uri_for('create')).to eq(url_foros)
    end

    context 'TolUser without consultoria changes to have consultoria and collective' do
      before (:each) do
        @user = create(
          :user,
          modulo_ids: [create_modulo_consultoria.id],
          iscolectivo: false,
          subid: 0,
          username: 'tonetti'
        )
        @user.has_consultoria_before = false
        @user.iscolectivo = true
        @user.save
        @foros = @user.send(:foro_to_update)
      end

      it 'builds a valid foro url for create a group with ctol permits' do
        url_foros = valid_uri_base % [base_url, 'crea_grupo.php', 'user_group=Ctonetti&permis=ctol' % [@user.email]]

        foro = @foros.first[:foro]

        expect(foro.build_uri_for('create_group')).to eq(url_foros)
      end

      it 'builds a valid foro urls for move each foro user personalization to a new group with ctol style' do
        url_partial = 'user_name=TOL%s&user_email=%s&user_pass=%s&user_groups=C%s&user_style=ctol'
        @user.user_subscriptions.each_with_index do |us, i|

          url_foros = valid_uri_base % [base_url, 'crea_usuario.php', url_partial % [us.id, us.perusuid, us.password, @user.username]]

          expect(@foros[1 + i][:foro].build_uri_for('create')).to eq(url_foros)
        end
      end
    end

    it "Toluser with consultoria and collective, it doesn't build a foro url for update" do
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: true,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )

      user.save
      foro = user.send('foro_to_update')

      expect(foro).to be_empty
    end

    it 'Toluser with consultoria and collective changes username, it builds a valid foro url for update' do
      url_foros = valid_uri_base % [base_url, 'modifica_grupo.php', 'group_name=Ctonetti&new_group_name=Ctonetti2']
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: true, 
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )
      user.username = 'tonetti2'
      user.save
      foro = user.send(:foro_to_update)

      expect(foro.first[:foro].build_uri_for('update_group')).to eq(url_foros)
    end

    it "TolUser with consultoria and without collective, it doesn't build a foro url for update" do
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: false,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )

      user.save
      foro = user.send(:foro_to_update)

      expect(foro).to be_empty
    end

    it 'TolUser with consultoria and without collective changes the username, it builds a valid foro url for update' do
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: false,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )
      user.username = 'tonetti2'
      user.save

      url_foros = valid_uri_base % [base_url, 'modifica_usuario.php', 'user_name=CTOLtonetti&new_user_name=CTOLtonetti2']

      foro = user.run_callbacks :update do
        user.send(:foro_to_update)
      end

      expect(foro.first[:foro].build_uri_for('update')).to eq(url_foros)
    end

    it 'TolUser with consultoria and without collective changes the password, it builds a valid foro url for update' do
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: false,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )
      user.password = valid_password
      user.save
      url_foros = valid_uri_base % [base_url, 'modifica_usuario.php', 'user_name=CTOLtonetti&user_pass=molamazo']

      foro = user.run_callbacks :update do
        user.send('foro_to_update')
      end

      expect(foro.first[:foro].build_uri_for('update')).to eq(url_foros)
    end

    it 'TolUser with consultoria and without collective changes the email, it builds a valid foro url for update' do
      user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: false,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )
      user.email = new_email
      user.save
      url_foros = valid_uri_base % [base_url, 'modifica_usuario.php', 'user_name=CTOLtonetti&user_email=sorianodepus2@tirant.com']

      foro = user.run_callbacks :update do
        user.send(:foro_to_update)
      end

      expect(foro.first[:foro].build_uri_for('update')).to eq(url_foros)
    end

    it 'TolUser updates the username, password, email then it builds a valid update url for foros' do
      @user = create(
        :user,
        modulo_ids: [create_modulo_consultoria.id],
        iscolectivo: false,
        subid: 0,
        has_consultoria_before: true,
        username: 'tonetti'
      )
      @user.username = 'tonetti3'
      @user.email = new_email
      @user.password = valid_password

      foro = @user.run_callbacks :update do
        @user.send('foro_to_update')
      end

      foro = foro.first[:foro]

      valid_update_url_for_foros = valid_uri_base % [base_url, 'modifica_usuario.php', 'user_name=CTOLtonetti3&user_email=sorianodepus2@tirant.com&user_pass=molamazo&new_user_name=CTOLtonetti3']

      url = foro.build_uri_for('update')

      expect(url).to eq(valid_update_url_for_foros)
    end
  end

  def valid_uri_base
    '%s/%s?sec_pass=medaigual&%s'
  end

  def valid_user_name
    'TOL12'
  end

  def valid_password
    'molamazo'
  end

  def valid_params
    {
      user_name: valid_user_name,
      user_email: 'sorianodepus@tirant.com',
      user_pass: valid_password,
      user_groups: 'tol',
      user_style: 'ctol'
    }
  end

  def empty_params
    {}
  end

  def valid_uri_created
    valid_uri_base % [base_url, 'crea_usuario.php', valid_params.map{|i, v| '%s=%s' % [i, v]}.join('&')]
  end

  def error_list
    ['user_name is required', 'user_email is required', 'user_pass is required', 'user_style is required', 'user_groups is required']
  end

  def valid_uri_destroy
    '%s/%s?sec_pass=medaigual&user_name=%s' % [base_url, 'borra_usuario.php', valid_user_name]
  end

  def valid_uri_update
    '%s/%s?sec_pass=medaigual&user_name=%s' % [base_url, 'modifica_usuario.php', valid_user_name]
  end

  def valid_user_group
    'TOL2425'
  end

  def valid_user_groups
    'tol'
  end

  def valid_user_style
    'ctol'
  end

  def new_email
    'sorianodepus2@tirant.com'
  end

  def valid_group_params
    { user_group: valid_user_group, permis: 'tol' }
  end

  def base_url
    'http://localhost:3001'
  end

  def valid_group_uri_created
    '%s/%s?sec_pass=medaigual&%s' % [base_url, 'crea_grupo.php', valid_group_params.map{|i,v| '%s=%s' % [i,v]}.join('&')]
  end

  def valid_group_uri_move
    '%s/%s?sec_pass=medaigual' % [base_url, 'grupo_mueve_a_grupos.php']
  end

  def valid_group_uri_update
    '%s/%s?sec_pass=medaigual&group_name=%s' % [base_url, 'modifica_grupo.php', valid_user_group]
  end

  def valid_group_uri_destroy
    '%s/%s?sec_pass=medaigual&user_group=%s' % [base_url, 'borra_grupo.php', valid_user_group]
  end

  def create_subsystem
    @subsystem ||= create(:subsystem, id: 0)
  end

  def create_modulo_consultoria
    @modulo ||= create(:modulo, id: 4)
  end

  def do_api_foros_unreachable
    allow(RestClient).to receive(:get).and_raise(RestClient::Exception)
  end

  def prepare_requests
    remove_request_stub(@group_request)
  end

  def create_tol_user_with_consultoria_and_collective
    build(
      :user,
      modulo_ids: [create_modulo_consultoria.id],
      iscolectivo: true,
      subid: 0,
      username: 'tonetti'
    )
  end

  def create_tol_user_with_consultoria_and_without_collective
    build(
      :user,
      modulo_ids: [create_modulo_consultoria.id],
      iscolectivo: false,
      subid: 0,
      username: 'tonetti',
      email: 'sorianodepus@tirant.com',
      password: 'sorianodepus'
    )
  end

  def create_tol_user_with_collective_and_without_consultoria
    build(:user, iscolectivo: true, subid: 0, username: 'tonetti')
  end

  def create_tol_user_without_consultoria_and_collective
    build(:user, iscolectivo: false, subid: 0, username: 'tonetti')
  end
end

# rubocop:enable RSpec/HookArgument
# rubocop:enable RSpec/ExampleLength
