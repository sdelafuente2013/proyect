require 'rails_helper'

describe 'User Logins Api', type: :request do
  let(:subscription_password) { 'mypassword' }

  before do
    Esp::User.delete_all
    stub_requests_to_api_foros
    allow(Esp::Foro).to receive(:new)
    @user = create(:user, subsystem: create_or_return_subsytem_tol)
    @user_expired = create(:user, subsystem: create_or_return_subsytem_tol,
                                  datelimit: Date.new(2001, 2, 3))
    @user_with_max_connections_to_zero = create(:user, subsystem: create_or_return_subsytem_tol,
                                                       maxconexiones: 0)
    @user_with_max_connections = create(:user, subsystem: create_or_return_subsytem_tol,
                                               maxconexiones: 10)
    @user_with_referer = create(:user, subsystem: create_or_return_subsytem_tol,
                                       referer: 'tirant.es')
    @user_is_demo = create(:user, subsystem: create_or_return_subsytem_tol, isdemo: true)
    @user_with_ips = create(:user, subsystem: create_or_return_subsytem_tol, referer: 'tirant.es')
    @user_with_grupo_materia = create(:user, subsystem: create_or_return_subsytem_tol)

    [@user, @user_expired, @user_with_max_connections, @user_with_grupo_materia,
     @user_with_max_connections_to_zero, @user_with_referer, @user_is_demo].each do |user|
      user.userIps.destroy_all
      user.total_sessions_class.by_user_id(user.id.to_s).destroy_all
    end

    create(:userIps, user: @user_with_ips, ipfrom: '114.215.73.42', ipto: '114.215.73.240')
    create_list(:user_session_esp, 11, userId: @user_with_max_connections.id)
    @subject_group = create(:subject_group)
    create(:gm_usuario, usuarioid: @user_with_grupo_materia.id, gmid: @subject_group.id)

    @subscription_with_user_is_demo = create(:user_subscription,
                                             perusuid: '2soriano@email.com',
                                             usuarioid: @user_is_demo.id,
                                             subid: @user_is_demo.subid)

    @subscription = create(:user_subscription,
                           usuarioid: @user.id,
                           subid: @user.subid,
                           password: subscription_password)

    @subscription_with_ips = create(:user_subscription,
                                    usuarioid: @user_with_ips.id,
                                    subid: @user_with_ips.subid,
                                    password: subscription_password)

    @subscription_with_referer = create(:user_subscription,
                                        usuarioid: @user_with_referer.id,
                                        subid: @user_with_referer.subid,
                                        password: subscription_password)
  end

  describe 'POST /user_logins' do
    context 'i call user_logins then the response is ok' do
      it 'when i send valid attributes from user' do
        valid_login_for(@user)
      end

      it 'when i send valid referer for user with referer' do
        valid_login_for(@user_with_referer, { referer: 'www.tirant.es' })
      end

      it 'when i send valid ips for user with ips' do
        valid_login_for(@user_with_ips, { ips: ['127.12.1.2', '114.215.73.240'] })
      end

      it 'when i send valid attributes from user subscription' do
        valid_login_for(@user, { username: @subscription.perusuid,
                                 password: subscription_password })
      end

      it 'when i send valid attributes from user subscription with user ips' do
        valid_login_for(@user_with_ips, { username: @subscription_with_ips.perusuid,
                                          password: subscription_password,
                                          ips: ['127.12.1.2', '114.215.73.240'] })
      end

      it 'when i send valid attributes from user subscription' do
        valid_login_for(@user_with_referer, { username: @subscription_with_referer.perusuid,
                                              password: subscription_password,
                                              referer: 'www.tirant.es' })
      end

      it 'when i send valid gmid from user with grupo materia' do
        valid_login_for(@user_with_grupo_materia, { gid: @subject_group.id })
      end
    end

    context 'i call user_logins then the response is unauthorized' do
      it 'when password is empty' do
        return_error_when_do_login_with(@user.username,
                                        '',
                                        @user.subid,
                                        4,
                                        'Password es requerido')
      end

      it 'when password is wrong' do
        return_error_when_do_login_with(@user.username,
                                        'sorianodepus',
                                        @user.subid,
                                        3,
                                        'Password incorrecta')
      end

      it 'when username is empty' do
        return_error_when_do_login_with(nil,
                                        '',
                                        @user.subid,
                                        4,
                                        'Username es requerido')
      end

      it 'when username not exists in users' do
        return_error_when_do_login_with('nomassorianos',
                                        'molamazo',
                                        @user.subid,
                                        4,
                                        'Usuario no encontrado')
      end

      it 'when datelimit is expired' do
        return_error_when_do_login_with(@user_expired.username,
                                        @user_expired.password,
                                        @user_expired.subid,
                                        9,
                                        'Subscripcion caducada')
      end

      it 'when max_connections is 0' do
        return_error_when_do_login_with(@user_with_max_connections_to_zero.username,
                                        @user_with_max_connections_to_zero.password,
                                        @user_with_max_connections_to_zero.subid,
                                        7,
                                        'Numero maximo de conexiones alcanzadas 0')
      end

      it 'when max_connections is 10 and user has 11 current sessions' do
        return_error_when_do_login_with(@user_with_max_connections.username,
                                        @user_with_max_connections.password,
                                        @user_with_max_connections.subid,
                                        7,
                                        'Numero maximo de conexiones alcanzadas 10')
      end

      it 'when login referer is invalid for user with referer setted' do
        return_error_when_do_login_with(@user_with_referer.username,
                                        @user_with_referer.password,
                                        @user_with_referer.subid,
                                        5,
                                        'Referer incorrecto',
                                        'www.asorinados.com')
      end

      it 'when login have empty ips for user with ips' do
        return_error_when_do_login_with(@user_with_ips.username,
                                        @user_with_ips.password,
                                        @user_with_ips.subid,
                                        1,
                                        'Acceso desde IP invalida')
      end

      it 'when login have invalid ips for user with ips' do
        return_error_when_do_login_with(@user_with_ips.username,
                                        @user_with_ips.password,
                                        @user_with_ips.subid,
                                        1,
                                        'Acceso desde IP invalida',
                                        nil, ['172.168.0.1', '172.168.3.1'])
      end

      describe 'when i do login with user_subscription' do
        it 'where user is demo' do
          return_error_when_do_login_with(@subscription_with_user_is_demo.perusuid,
                                          subscription_password,
                                          @user_with_ips.subid,
                                          12,
                                          'Usuario sin permisos')
        end

        it 'where user has ips and ips attributes are invalid' do
          return_error_when_do_login_with(@subscription_with_ips.perusuid,
                                          subscription_password,
                                          @subscription_with_ips.subid,
                                          1,
                                          'Acceso desde IP invalida',
                                          nil,
                                          ['172.168.0.1'])
        end

        it 'where user has referer and referer attribute is invalid' do
          return_error_when_do_login_with(@subscription_with_referer.perusuid,
                                          subscription_password,
                                          @subscription_with_referer.subid,
                                          5,
                                          'Referer incorrecto',
                                          'www.asorinados.com')
        end

        it 'where user has grupomateria and gmid attribute is invalid' do
          return_error_when_do_login_with(@user_with_grupo_materia.username,
                                          @user_with_grupo_materia.password,
                                          @user_with_grupo_materia.subid,
                                          8,
                                          'El usuario no tiene asignado el grupo de materias',
                                          nil, [], '114141414141414')
        end
      end
    end
  end

  def return_error_when_do_login_with(username, password, subid, code = nil, message = nil, referer = nil, _ips = [], gmid = '')
    invalid_attributes = { username: username, password: password, subid: subid,
                           referer: referer, gmid: gmid }
    post '/esp/user_logins', params: invalid_attributes
    expect(response).to have_http_status(:unauthorized)

    json_object = JSON.parse(response.body)
    expect(json_object['code']).to eq(code)
    expect(json_object['message']).to eq(message)
  end

  def valid_login_for(user, extra_attributes = {})
    valid_attributes = { username: user.username, password: user.password,
                         subid: user.subid }

    post '/esp/user_logins', params: valid_attributes.merge(extra_attributes)
    expect(response).to have_http_status(:created)

    get '/esp/user_sessions/%s' % json['object']['sessionid']

    expect(response).to have_http_status(:ok)
    expect(json['object']['invalidated']).to be_falsey
    expect(json['object']['userId']).to eq(user.id.to_s)
  end
end
