require 'rails_helper'

describe 'UserLogin' do

  before(:each) do
    Esp::User.delete_all
    stub_requests_to_api_foros
    allow(Esp::Foro).to receive(:new)
    create_or_return_subsytem_tol
    Esp::User.new().total_sessions_class.destroy_all
  end
  
  describe 'login_is_valid?' do

    context 'when login username is empty' do
      before do
        @login = build(:user_login, :username => nil)
      end

      it 'then i have a Exception::Login :username_required' do
        expect_exception_for("username_required", @login, 4, "Username es requerido", "username required")
      end
    
    end

    context 'when login password is empty' do
      before do
        @login = build(:user_login, :password => nil)
      end

      it 'then i have a Exception::Login :password_required' do
        expect_exception_for("password_required", @login, 4, "Password es requerido", "password required")
      end
    
    end

    context 'when the username not exists in user model' do
      before do
        @login = build(:user_login, :username => "sorianonoentra")
      end

      it 'then i have a Exception::Login :invalid_user' do
        expect_exception_for("invalid_user", @login, 4, "Usuario no encontrado", "usuario=sorianonoentra no encontrado en Subsystem")
      end
    
    end
    
    describe "when the username is a email" do
      before do
        Esp::UserSubscription.where(:perusuid => '1soriano@email.com').delete_all
        Esp::User.delete_all

        @user_for_login = create(:user, username: 'sorianoentra', password: 'sorianodepus', subsystem: create_or_return_subsytem_tol)
        @user_for_login.userIps.destroy_all
        
        @subscription = create(:user_subscription,
          perusuid: '1soriano@email.com',
          password: "mypassword",
          usuarioid: @user_for_login.id,
          subid: @user_for_login.subid,
        )
      end
      
      context 'and email exists in user_subscriptions and password is valid' do
        before do
          @login = Esp::UserLogin.new(:username => "1soriano@email.com", :password => "mypassword", :subid => @user_for_login.subid)
        end
        
        it "then login is valid?" do
          expect(@login.valid?).to be_truthy
          expect(@login.user_subscription).to eq(@subscription)
          expect(@login.user).to eq(@user_for_login)
          expect(@login.username).to eq(@user_for_login.username)
          expect(@login.password).to eq(@user_for_login.password)
          
          login = Esp::UserLogin.authentificate({:username => "1soriano@email.com", :password => "mypassword", :subid =>  @user_for_login.subid})

          expect(login.sessionid).to_not be_nil
          session = Esp::UserSession.find(login.sessionid)

          expect(session.invalidated).to be_falsey
          expect(session.userId).to eq(@user_for_login.id.to_s)
          
          expect(session.sessionAttributes["subscriptionid"]).to eq(@subscription.id)
          expect(session.sessionAttributes["perusuid"]).to eq(@subscription.perusuid)
          expect(session.sessionAttributes["perusername"]).to eq(@subscription.username)
          expect(session.sessionAttributes["perusuusuario"]).to eq({"id"=>@user_for_login.id, "username"=>@user_for_login.username})
        end
        
      end
      
      context 'and email exists in user_subscriptions and password is valid but user is demo' do
        before do
          @user_for_login.isdemo=true
          @user_for_login.save
          @login = Esp::UserLogin.new(:username => "1soriano@email.com", :password => "mypassword", :subid => @user_for_login.subid)
        end
        
        it "then i have a Exception::Login :user_exceed_max_connections" do
          expect_exception_for("user_not_permissions", @login, 12, "Usuario sin permisos", "Usuario sin permisos sorianoentra  personalizado 1soriano@email.com")
        end
        
      end
    end

    describe 'when the username exists in user model' do
      
      before do
        Esp::User.delete_all
        stub_requests_to_api_foros
        @user_for_login = create(:user, username: 'sorianoentra', password: 'sorianodepus', subsystem: create_or_return_subsytem_tol)
        @user_for_login.userIps.destroy_all
      end

      context 'but password is invalid' do
        it 'then i have a Exception::Login :wrong_password' do
          @login = build(:user_login, :username => "sorianoentra", :password => "sorianowrongpass")
          expect_exception_for("wrong_password", @login, 3, "Password incorrecta", "password=#sorianowrongpass#")
        end
      end
      
      context 'with password is valid' do
        before do
          @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus")
        end
        
        it "then login is valid?" do
          expect(@login.valid?).to be_truthy
          login = Esp::UserLogin.authentificate({:username => "sorianoentra", :password => "sorianodepus"})
          expect(login.actualizaciones).to be_falsey
          expect(login.sessionid).to_not be_nil
          session = Esp::UserSession.find(login.sessionid)

          expect(session.invalidated).to be_falsey
          expect(session.userId).to eq(@user_for_login.id.to_s)
        end
        
        context 'with origenid sent' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :origenid => "castanya")
          end
        
          it "then login is valid? and session has origenid in session attributes" do
            expect(@login.valid?).to be_truthy
            login = Esp::UserLogin.authentificate({:username => "sorianoentra", :password => "sorianodepus", :origenid => "castanya"})
            expect(login.actualizaciones).to be_falsey
            expect(login.sessionid).to_not be_nil
            session = Esp::UserSession.find(login.sessionid)

            expect(session.invalidated).to be_falsey
            expect(session.userId).to eq(@user_for_login.id.to_s)
            expect(session.sessionAttributes["origenid"]).to eq("castanya")
          end
        end
        
        context 'with origen sent and user has not actualizaciones' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :origenid => "castanya")
            @user_for_login.actualizaciones = false
            @user_for_login.save
          end
        
          it "then login is valid? and session actualizaciones attribute is false" do
            expect(@login.valid?).to be_truthy
            login = Esp::UserLogin.authentificate({:username => "sorianoentra", :password => "sorianodepus", :origen => "castanya"})
            expect(login.actualizaciones).to be_falsey
            expect(login.sessionid).to_not be_nil
            session = Esp::UserSession.find(login.sessionid)

            expect(session.invalidated).to be_falsey
            expect(session.userId).to eq(@user_for_login.id.to_s)

          end
        end
        
        context 'with origen sent and user has actualizaciones' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :origenid => "castanya")
            @user_for_login.actualizaciones = true
            @user_for_login.save
          end
        
          it "then login is valid? and session actualizaciones attribute is true" do
            expect(@login.valid?).to be_truthy
            login = Esp::UserLogin.authentificate({:username => "sorianoentra", :password => "sorianodepus", :origen => "castanya"})
            expect(login.actualizaciones).to be_truthy
            expect(login.sessionid).to_not be_nil
            session = Esp::UserSession.find(login.sessionid)

            expect(session.invalidated).to be_falsey
            expect(session.userId).to eq(@user_for_login.id.to_s)
          end
        end
        
        
        context 'with datelimit expired' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus")
            @user_for_login.datelimit = Date.new(2001,2,3)
            @user_for_login.save
          end
        
          it "then i have a Exception::Login :user_exceed_max_connections" do
            expect_exception_for("user_expired", @login, 9, "Subscripcion caducada", "Subscripcion caducada. Fecha=2001-02-03")
          end
        end
        
        context 'and maxconexiones is zero' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus")
            @user_for_login.maxconexiones=0
            @user_for_login.save
          end
        
          it "then i have a Exception::Login :user_exceed_max_connections" do
            expect_exception_for("user_exceed_max_connections", @login, 7, "Numero maximo de conexiones alcanzadas 0", "num. maximo conexiones alcanzado=0")
          end
        end
        
        context 'and maxconexiones exceed' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus")
            allow(@user_for_login).to receive(:total_sessions).and_return(@user_for_login.maxconexiones+1)
          end
        
          it "then i have a Exception::Login :user_exceed_max_connections" do
            expect_exception_for("user_exceed_max_connections", @login, 7, "Numero maximo de conexiones alcanzadas %s" % @user_for_login.maxconexiones, "num. maximo conexiones alcanzado=%s" % @user_for_login.maxconexiones)
          end
        end
        
        context 'with valid referer' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :referer => "tirant.com")
            @user_for_login.referer="tirant.com"
            @user_for_login.save
          end
        
          it "then login is valid?" do
            expect(@login.valid?).to be_truthy
          end
        end
        
        context 'with invalid referer' do
          before do
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :referer => "tirant.es")
            @user_for_login.referer="tirant.com"
          end
        
          it "then i have a Exception::Login :invalid_referer" do
             expect_exception_for("invalid_referer", @login, 5, "Referer incorrecto", "Llega desde (tirant.es). Registrado=()")
          end
        end
        
        context 'with ips 114.215.73.42 to 114.215.73.240' do
          before do
            @user_for_login_ips = create(:userIps, :user => @user_for_login, :ipfrom => '114.215.73.42', :ipto => '114.215.73.240')
            @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus")
          end
        
          it "then login is valid? with ip 114.215.73.80" do
            @login.ips = ["114.215.73.80"]
            expect(@login.valid?).to be_truthy
          end
          
          it "then login is valid? with ip 114.215.73.42" do
            @login.ips = ["114.215.73.42"]
            expect(@login.valid?).to be_truthy
          end
          
          it "then login is valid? with ip 114.215.73.240" do
            @login.ips = ["114.215.73.240"]
            expect(@login.valid?).to be_truthy
          end
          
          it "then i have a Exception::Login :invalid_ips with ip invalid 250.215.73.240" do
            @login.ips = ["250.215.73.240"]
            expect_exception_for("invalid_ips", @login, 1, "Acceso desde IP invalida", "Llega desde (250.215.73.240). Registradas=(114.215.73.42 to 114.215.73.240)")
          end
          
          it "then i have a Exception::Login :invalid_ips with ips empty" do
            @login.ips = []
            expect_exception_for("invalid_ips", @login, 1, "Acceso desde IP invalida", "Llega desde (). Registradas=(114.215.73.42 to 114.215.73.240)")
            
            @login.ips = nil
            expect_exception_for("invalid_ips", @login, 1, "Acceso desde IP invalida", "Llega desde (). Registradas=(114.215.73.42 to 114.215.73.240)")
          end
        end
        
      end
      
      context 'with invalid gmid' do
        before do
          @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :gmid => "100000")
          @subject_group = create(:subject_group)
          create(:gm_usuario, :usuarioid => @user_for_login.id, :gmid => @subject_group.id)
        end
      
        it "then i have a Exception::Login :invalid_gmid" do
           expect_exception_for("invalid_gmid", @login, 8, "El usuario no tiene asignado el grupo de materias", "Grupo materias=%s" % @subject_group.descripcion)
        end
      end
      
      context 'with valid gmid' do
        before do
          @subject_group = create(:subject_group)
          create(:gm_usuario, :usuarioid => @user_for_login.id, :gmid => @subject_group.id)
          @login = build(:user_login, :username => "sorianoentra", :password => "sorianodepus", :gmid => @subject_group.id)
        end
      
        it "then login is valid?" do
          expect(@login.valid?).to be_truthy
        end
      end

    end

  end

  def expect_exception_for(exception_type, login, code, message, access_error_message=nil)
    exception= Exception::Login.new(exception_type.to_sym, login)
    allow(login).to receive(:valid?).and_raise(exception)
    expect(exception.to_hash).to eq({message: message, code: code })
    expect(exception.access_error_description).to eq(access_error_message)
    access_error = exception.access_error
    expect(access_error.descripcion).to eq(access_error_message)
    expect(access_error.username).to eq(login.username)
    expect(access_error.tipo_error_acceso_id).to eq(code)
    expect(access_error.usuarioid).to eq(login.user.try(:id))
    expect(access_error.subid).to eq(login.subid)
    expect(access_error.tipo_peticion).to eq(login.class.access_error_class::REQUEST_TYPE_LOGIN)
  end
  
end
