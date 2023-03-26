require 'rails_helper'

describe 'User' do
  before(:each) do
    Esp::User.delete_all
    stub_requests_to_api_foros
  end

  it 'can be created' do
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: subsystem,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com'
    )

    result = user.save

    expect(result).to be_truthy
  end

  context 'when user has product with jurisprudencia origenes' do
    before do
      @product = create(:product)
      @jurisprudencia_origen_parent = create(:jurisprudencia_origen_esp)
      @jurisprudencia_origen_child = create(:jurisprudencia_origen_esp, :padre_id => @jurisprudencia_origen_parent.id)
      @product_origen = create(:product_origen_esp, productoid: @product.id, origenid: @jurisprudencia_origen_child.id)

      @user_with_origenes = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'user_with_origenes@user.com'
      )
      @user_with_origenes.products << @product
      @user_with_origenes.save
    end

    it "then i return a list from origenes in jurisprudencia_origenes method" do
      expect(@user_with_origenes.jurisprudencia_origenes.sort).to eq([@jurisprudencia_origen_parent.id, @jurisprudencia_origen_child.id])
    end
  end
  
  context 'when user has product with jurisprudencia jurisdicciones' do
    before do
      @product = create(:product)
      @jurisprudencia_jurisdiccion = create(:jurisprudencia_jurisdiccion_esp)
      @product_jurisdiccion = create(:product_jurisdiccion_esp, productoid: @product.id, jurisdiccionid: 
      @jurisprudencia_jurisdiccion.id)

      @user_with_jurisdicciones = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'user_with_origenes@user.com'
      )
      @user_with_jurisdicciones.products << @product
      @user_with_jurisdicciones.save
    end

    it "then i return a list from origenes in jurisprudencia_jurisdicciones method" do
      expect(@user_with_jurisdicciones.jurisprudencia_jurisdicciones.sort).to eq([@jurisprudencia_jurisdiccion.id])
    end
  end

  context 'when i delete user' do
    before do
      @backoffice_user = create(:backoffice_user)
      @user_to_deleted = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'user_to_delete@user.com'
      )
      @user_to_deleted.save

      user_personalizations = response_user_personalizations
      allow(OfficesClient::BackofficeDespacho).to receive(:updateall).and_return(0)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return(user_personalizations)

      @user_to_deleted.backoffice_user=@backoffice_user
      @user_id = @user_to_deleted.id
      @fecha_alta = @user_to_deleted.fechaalta
      @user_to_deleted.destroy!
      @deleted_user = Esp::DeletedUser.where(:userid => @user_id).first
    end

    it 'then i have a deleted_user object created' do
      expect(@deleted_user).to_not be_nil
      expect(@deleted_user.username).to eq('user_to_delete@user.com')
      expect(@deleted_user.password).to eq('12345678')
      expect(@deleted_user.subid).to eq(subsystem.id)
      expect(@deleted_user.userid).to eq(@user_id)
      expect(@deleted_user.fechaalta).to eq(@fecha_alta)
      expect(@deleted_user.backoffice_user_id).to eq(@backoffice_user.id)
      expect(@deleted_user.backoffice_user_name).to eq(@backoffice_user.email)
      expect(@deleted_user.fechaborrado).to_not be_nil
    end

  end

  context 'requires email if' do
    it 'has to create a personalization account' do
      email_presence_error = {:email => [{:error=>:blank}, {:error=>:invalid, :value=>nil}]}
      user = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        add_perso_account: true
      )

      user.save

      expect(user.errors.details).to eq(email_presence_error)
    end

    it 'has not to be collective and has consultant for Spain' do
      consultant_module = create(:modulo, id: Esp::Modulo.consultoria_ids[0])
      email_presence_error = {:email => [{:error=>:blank}, {:error=>:invalid, :value=>nil}]}
      user = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        iscolectivo: false,
        modulos: [consultant_module]
      )

      user.save

      expect(user.errors.details).to eq(email_presence_error)
    end

    it 'has not to be collective and has consultant for Mexico' do
      consultant_module = mex_consultant_modulo
      email_presence_error = {:email => [{:error=>:blank}, {:error=>:invalid, :value=>nil}]}
      user = Mex::User.new(
        access_type: mex_access_type,
        user_type_group: mex_user_type_group,
        subsystem: mex_subsystem,
        access_type_tablet: mex_access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        iscolectivo: false,
        modulos: [consultant_module]
      )

      user.save

      expect(user.errors.details).to eq(email_presence_error)
    end
  end

  it 'has a cloud library user' do
    cloudlibrary_user = 1
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: subsystem,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      email: 'test@user.com',
      username: 'test@user.com',
      cloudlibrary_user: cloudlibrary_user
    )
    user.save

    expect(user.cloudlibrary_user).to eq(cloudlibrary_user)
  end

  it 'can be updated' do
    new_maxconexiones = 2
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: subsystem,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      email: 'test@user.com',
      username: 'test@user.com'
    )
    user.save

    result = user.update(maxconexiones: new_maxconexiones)

    expect(result).to eq(true)
    expect(user.maxconexiones).to eq(new_maxconexiones)
  end

  it 'has translated errors' do
    I18n.with_locale(:es) do
      user = Esp::User.new()

      user.save

      error = user.errors.messages[:username].first
      expect(error).to eq("no puede estar en blanco")
    end
  end

  context 'fills permissions with a default' do
    it 'for Spain' do
      spain_default_permissions = '00000000000000000000000000000000000'
      user = Esp::User.new(
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        email: 'test@user.com',
        username: 'test@user.com'
      )

      user.save

      expect(user.permisos).to eq(spain_default_permissions)
    end

    it 'for Mexico' do
      mexico_default_permissions = '000000000000000'
      user = Mex::User.new(
        access_type: mex_access_type,
        user_type_group: mex_user_type_group,
        subsystem: mex_subsystem,
        access_type_tablet: mex_access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        email: 'test@user.com',
        username: 'test@user.com'
      )

      user.save

      expect(user.permisos).to eq(mexico_default_permissions)
    end

    it 'for Latam' do
      latam_default_permissions = '00000000'
      user = Latam::User.new(
        access_type: latam_access_type,
        user_type_group: latam_user_type_group,
        subsystem: latam_subsystem,
        access_type_tablet: latam_access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        email: 'test@user.com',
        username: 'test@user.com'
      )

      user.save

      expect(user.permisos).to eq(latam_default_permissions)
    end
  end

  it 'doesnt fill permissions with a default if it has permissions' do
    any_permissions = '01010101010101010'
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: subsystem,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      email: 'test@user.com',
      username: 'test@user.com',
      permisos: any_permissions
    )

    user.save

    expect(user.permisos).to eq(any_permissions)
  end

  it 'fills creation and revision date on save' do
    right_now = Time.now.utc
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: subsystem,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      email: 'test@user.com',
      username: 'test@user.com'
    )

    user.save

    expect((user.fechaalta - right_now).abs).to be < 10
    expect((user.fecharevision - right_now).abs).to be < 10
  end

  context 'when independent offices management is enabled' do
    let(:user) { create(:user, subid: any_subsystem.id, independent_offices: true) }

    before(:each) do
      allow(OfficesClient::Connection).to receive(:new).and_return(StubConnection.new)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return({ 'result' => [] })
    end

    describe '#update!' do
      it 'does not update offices when changing datelimit' do
        expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

        user.update!(datelimit: Time.current)
      end

      it 'does not update offices when changing maxconexiones' do
        expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

        user.update!(maxconexiones: 0)
        user.update!(maxconexiones: 2)
      end

      context 'for spain' do
        let(:despachos_module) { create(:modulo, id: Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM) }

        context 'for tirantonline subsystem' do
          let(:tirantonline_subsystem) { create(:subsystem, name: 'Tirantonline', id: 0) }
          let(:user) { create(:user, maxconexiones: 1, subid: tirantonline_subsystem.id, independent_offices: true) }

          it 'does not update offices when changing offices plus module' do
            expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

            user.update!(modulo_ids: [despachos_module.id])
            user.update!(modulo_ids: [])
          end
        end

        context 'for other subsystems' do
          let(:another_subsystem) { create(:subsystem, name: 'Another', id: 1) }
          let(:user) { create(:user, maxconexiones: 1, subid: another_subsystem.id, independent_offices: true) }

          it 'does not update offices when changing offices plus module' do
            expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

            user.update!(modulo_ids: [despachos_module.id])
            user.update!(modulo_ids: [])
          end
        end
      end

      context 'for mexico' do
        let(:user) { mex_user(maxconexiones: 1, independent_offices: true) }

        it 'does not update offices when changing offices plus module' do
          expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

          user.update!(modulo_ids: [mex_despacho_premium.id])
          user.update!(modulo_ids: [])
        end
      end

      context 'for latam' do
        let(:pais_latam) { create(:pais_latam) }
        let(:user) {
          create(
            :user_latam,
            maxconexiones: 1,
            subsystem: pais_latam.subsystem,
            modulo_ids: [],
            independent_offices: true
          )
        }
        let(:despachos_module) { create(:modulo_latam, id: Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM) }

        it 'does not update offices when changing offices plus module' do
          expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

          user.update!(modulo_ids: [despachos_module.id])
          user.update!(modulo_ids: [])
        end
      end
    end

    describe '#destroy' do
      it 'does not deactivate offices' do
        expect(OfficesClient::BackofficeDespacho).not_to receive(:updateall)

        user.backoffice_user = create(:backoffice_user)
        user.destroy!
      end
    end
  end

  context 'change its offices when' do
    before(:each) do
      allow(OfficesClient::Connection).to receive(:new).and_return(StubConnection.new)
    end

    it 'deactives its offices before delete it self' do
      user = create(:user, subid: any_subsystem.id)
      backoffice_user = create(:backoffice_user)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return({ 'result' => [] })
      expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {active: false})
      user.backoffice_user=backoffice_user
      user.destroy!

      expect(Esp::User.count).to be_zero
    end

    it 'updates offices datelimit when its datelimit is updated' do
      one_day = 1
      new_datelimit = DateTime.now
      datelimit = new_datelimit - one_day
      modulo = Mex::Modulo.where(:id => 9).first || Mex::Modulo.create(id: 9, nombre: 'Some module')
      user = mex_user(datelimit: datelimit, subid: any_subsystem.id, modulo_ids: modulo.id)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return({ 'result' => [] })
      expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, { date_limit: new_datelimit.to_date.to_s, active: false})

      user.update!({ datelimit: new_datelimit })

      expect(user.datelimit.to_i).to eq(new_datelimit.to_i)
    end

    context 'changes maxconnections to zero then' do
      it 'deactivates its offices' do
        modulo =  Mex::Modulo.where(:id => 7).first || Mex::Modulo.create(id: 7, nombre: 'Offices plus')
        user = mex_user(maxconexiones: 1, modulo_ids: modulo.id )
        allow(CloudLibrary::UserPersonalization).to receive(:list).and_return({ 'result' => [] })
        expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {active: false})

        user.update!(maxconexiones: 0)

        expect(user.maxconexiones).to be_zero
      end
    end

    context 'from Mexico' do
      before do
        @despacho_premium = mex_despacho_premium
      end

      context 'actives its offices' do
        it 'when has Offices Plus module and starts allowing connections' do
          user = mex_user(modulo_ids: @despacho_premium.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {active: true})

          user.update!(maxconexiones: 1)
        end

        it 'when allow connections and receives Offices Plus module' do
          user = mex_user(maxconexiones: 1)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {active: true})

          user.update!(modulo_ids: [@despacho_premium.id])
        end
      end

      context 'deactivates its offices' do
        it 'when removes Offices Plus module' do
          user = mex_user(maxconexiones: 1, modulo_ids: @despacho_premium.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {active: false})

          user.update!(modulo_ids: [])
        end
      end
    end

    context 'from Spain' do
      context 'actives its offices' do
        before do
          @subsystem_tirantonline = create(:subsystem, name: 'Tirant Online', id: 0)
          @another_subsystem = create(:subsystem, name: 'Another Subsystem', id: 1)
          @modulo = create(:modulo, id: Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM)
        end

        it 'when allow connections and receives the subsystem tirantonline' do
          user = create(:user, maxconexiones: 1, subid: @another_subsystem.id, modulo_ids: @modulo.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {:active=>true, :premium=>true})

          user.update!(subid: @subsystem_tirantonline.id)
        end

        it 'has subsystem tirantonline and starts allowing connections' do
          user = create(:user, maxconexiones: 0, subid: @subsystem_tirantonline.id, modulo_ids: @modulo.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {:active=>true, :premium=>true})

          user.update!(maxconexiones: 1)
        end
      end

      context 'change offices status' do

        let(:other_module) { create(:modulo, id: (Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM+1)) }

        before do
          @subsystem_tirantonline = create(:subsystem, name: 'Tirant Online', id: 0)
          @offices_premium = create(:modulo, id: Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM)
        end

        it 'to not premium when removes offices plus and has tirantonline' do
          user = create(:user, subid: @subsystem_tirantonline.id, modulo_ids: @offices_premium.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {:active=>true, :premium=>false})

          user.update!(modulo_ids: [])
        end

        it 'to not premium when updated without premium' do
          user = create(:user, subid: @subsystem_tirantonline.id, modulo_ids: @offices_premium.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {:active=>true, :premium=>false})

          user.update!(modulo_ids: [ other_module.id ])
        end

        it 'to premium when receives offices plus and has tirantonline' do
          user = create(:user, subid: @subsystem_tirantonline.id)

          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(any_args, {:active=>true, :premium=>true})

          user.update!(modulo_ids: [@offices_premium.id])
        end
      end
    end

    context 'for Latam' do
      let(:offices_module) { create(:modulo_latam, id: 9) }
      let(:pais_latam) { create(:pais_latam) }

      context 'when user has offices module added' do
        let(:user_latam) { create(:user_latam, subsystem: pais_latam.subsystem, modulo_ids: []) }
        let(:user_data) { { 'usuariotol' => user_latam.id, 'tolgeo' => 'latam', 'isocode' => pais_latam.codigo_iso_2digits } }

        it 'activates its offices' do
          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(anything, user_data, { active: true})
          user_latam.update!(modulo_ids: [offices_module.id])
        end
      end

      context 'when user has offices module removed' do
        let(:user_latam) { create(:user_latam, subsystem: pais_latam.subsystem, modulo_ids: offices_module.id) }
        let(:user_data) { { 'usuariotol' => user_latam.id, 'tolgeo' => 'latam', 'isocode' => pais_latam.codigo_iso_2digits } }

        it 'deactivates its offices' do
          expect(OfficesClient::BackofficeDespacho).to receive(:updateall).with(anything, user_data, { active: false })
          user_latam.update!(modulo_ids: [])
        end
      end
    end
  end

  context 'disables its UserPersonalizations' do
    before(:each) do
      @today = '22-06-2018'
      allow(DateTime).to receive(:now).and_return(@today)
      user_personalizations = response_user_personalizations
      allow(OfficesClient::BackofficeDespacho).to receive(:updateall).and_return(0)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return(user_personalizations)
      @first_user_personalization = user_personalizations['result'].first
      @second_user_personalization = user_personalizations['result'].last
      @backoffice_user = create(:backoffice_user)
    end

    it 'when it is deleted' do
      user_with_personalizations = esp_user
      user_with_personalizations.backoffice_user = @backoffice_user
      user_with_personalizations.destroy!

      expect(@first_user_personalization.datelimit).to eq(@today)
      expect(@second_user_personalization.datelimit).to eq(@today)
    end

    it 'when it does not allow connections' do
      user_with_personalizations = esp_user(maxconexiones: 10)

      user_with_personalizations.update!({ maxconexiones: 0 })

      expect(@first_user_personalization.datelimit).to eq(@today)
      expect(@second_user_personalization.datelimit).to eq(@today)
    end

    it 'when it updates datelimit but does not allow connections' do
      tomorrow = '23-06-2018'
      user_with_personalizations = esp_user(maxconexiones: 0)

      user_with_personalizations.update!({ datelimit: tomorrow })

      expect(@first_user_personalization.datelimit).to eq(@today)
      expect(@second_user_personalization.datelimit).to eq(@today)
    end
  end

  context "updates UserPersonalizations's datelimit to its self" do
    it 'when allows connections' do
      tomorrow = '23-06-2018'
      @today = '22-06-2018'
      allow(DateTime).to receive(:now).and_return(@today)
      user_personalizations = response_user_personalizations
      allow(OfficesClient::BackofficeDespacho).to receive(:updateall).and_return(0)
      allow(CloudLibrary::UserPersonalization).to receive(:list).and_return(user_personalizations)
      @first_user_personalization = user_personalizations['result'].first
      @second_user_personalization = user_personalizations['result'].last
      user_with_personalizations = esp_user(maxconexiones: 10)

      user_with_personalizations.update!({ datelimit: tomorrow })

      expect(@first_user_personalization.datelimit).to eq(tomorrow)
      expect(@second_user_personalization.datelimit).to eq(tomorrow)
    end
  end

  context 'when updates access type tablet' do
    before do
      @deny_to_all = create(:access_type_tablet, id: 1)
      @access_to_all = create(:access_type_tablet, id: 2)
      @access_by_domain = create(:access_type_tablet, id: 3)
      @another_subsystem = Esp::Subsystem.where(:id => 0).first || create(:subsystem, name: 'Another Subsystem', id: 0)
      allow(OfficesClient::BackofficeDespacho).to receive(:updateall).and_return(0)
    end

    it 'to access to all its subscriptions' do
      user = create(:user, access_type_tablet: @deny_to_all)
      not_allowed_subscription = create(:user_subscription, user: user, acceso_tablet: false)
      enable_tablet_access = {
        access_type_tablet: @access_to_all
      }

      user.update!(enable_tablet_access)

      allowed_subscriptions = Esp::UserSubscription.find(not_allowed_subscription.id)
      expect(allowed_subscriptions.acceso_tablet).to be_truthy
    end

    it 'to deny to all its subscriptions' do
      user = create(:user, access_type_tablet: @access_to_all)
      allowed_subscription = create(:user_subscription, user: user, acceso_tablet: true)
      disable_tablet_access = {
        access_type_tablet: @deny_to_all
      }

      user.update!(disable_tablet_access)

      not_allowed_subscription = Esp::UserSubscription.find(allowed_subscription.id)
      expect(not_allowed_subscription.acceso_tablet).to be_falsy
    end

    it 'to access by domain its subscriptions' do
      user = create(:user, access_type_tablet: @deny_to_all, dominios: '@match, @another')
      unmatched_domain = create(:user_subscription, user: user, acceso_tablet: false, perusuid: 'user@n0m4tch.com')
      matched_domain = create(:user_subscription, user: user, acceso_tablet: false, perusuid: 'user@match.es')
      enables_for_domain = {
        access_type_tablet: @access_by_domain
      }

      user.update!(enables_for_domain)

      not_allowed_subscription = Esp::UserSubscription.find(unmatched_domain.id)
      allowed_subscription = Esp::UserSubscription.find(matched_domain.id)
      expect(not_allowed_subscription.acceso_tablet).to be_falsy
      expect(allowed_subscription.acceso_tablet).to be_truthy
    end
  end

  context 'for Foros' do
    context 'Esp' do
      context 'not allowed subsystems' do
        before do
          @user = build_esp_non_tirant_user
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'does not do nothing when creates non TirantOnline users' do

          expect(Esp::Foro).not_to receive(:new)
          expect(Esp::GroupForo).not_to receive(:new)

          @user.save
        end

        it 'does not do nothing when deletes non TirantOnline users' do
          @user.save

          expect(Esp::Foro).not_to receive(:new)
          expect(Esp::GroupForo).not_to receive(:new)
          @user.destroy
        end

        it 'does not do nothing when change non TirantOnline users' do
          @user.save

          expect(Esp::Foro).not_to receive(:new)
          expect(Esp::GroupForo).not_to receive(:new)

          @user.update(username: 'change_username')
        end
      end

      context 'it has consultant and is collective' do
        before do
          @user = build_esp_user_with_consultant_and_is_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'is created it creates a foro group' do
          foro_group = {:user_group=>"Ctest@user.com", :permis=>"ctol"}

          expect(Esp::GroupForo).to receive(:new).with(foro_group)

          @user.save
        end

        it 'deletes foro group when it is deleted' do
          @user.save
          foro_group = {:user_group=>"Ctest@user.com", :disable_users=>1}

          expect(Esp::GroupForo).to receive(:new).with(foro_group)

          @user.destroy
        end

        it 'changes foro users username when it is changed its username' do
          @user.save
          foro_group = {:group_name=>"Ctest@user.com", :new_group_name=>"Cchange_username"}

          expect(Esp::GroupForo).to receive(:new).with(foro_group)

          @user.update(username: 'change_username')
        end

        it 'moves foro users and deletes the group when changes to without consultant' do
          @user.save
          foro_users = {:user_group=>"Ctest@user.com", :user_groups=>"tol", :user_style=>"ctol"}
          foro_group = {:user_group=>"Ctest@user.com"}

          expect(Esp::GroupForo).to receive(:new).with(foro_users)
          expect(Esp::GroupForo).to receive(:new).with(foro_group)

          @user.update(modulos: [])
        end

        it 'moves foro users, deletes de foro group and creates foro user when changes to non collective' do
          @user.save
          foro_users = {:user_group=>"Ctest@user.com", :user_groups=>"tol", :user_style=>"ctol"}
          foro_group = {:user_group=>"Ctest@user.com"}
          foro_user = {:user_name=>"CTOLtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctol", :user_style=>"ctol"}

          expect(Esp::GroupForo).to receive(:new).with(foro_users)
          expect(Esp::GroupForo).to receive(:new).with(foro_group)
          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(iscolectivo: false)
        end
      end

      context 'it has consultant and is not collective' do
        before do
          @user = build_esp_user_with_consultant_and_without_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'is created it creates a foro user' do
          foro_user = {:user_name=>"CTOLtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctol", :user_style=>"ctol"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.save
        end

        it 'deletes foro user when it is deleted' do
          @user.save
          foro_user = {:user_name=>"CTOLtest@user.com"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.destroy
        end

        it 'changes foro users username when it is changed its username' do
          @user.save
          foro_user = {:user_name=>"CTOLtest@user.com", :new_user_name=>"CTOLchange_username"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(username: 'change_username')
        end

        it 'changes foro users password when it is changed its password' do
          @user.save
          foro_user = {:user_name=>"CTOLtest@user.com", :user_pass=>"change_password"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(password: 'change_password')
        end

        it 'changes foro users email when it is changed its email' do
          @user.save
          foro_user = {:user_name=>"CTOLtest@user.com", :user_email=>"change@email.com"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(email: 'change@email.com')
        end

        it 'deletes foro user, creates group and create users when it changes to be colective' do
          subscription_id = 2345
          subscription = create(:user_subscription, id: subscription_id, perusuid: 'subscription@email.com', password: password)
          @user.save
          @user.update(user_subscriptions: [subscription])
          foro_user = {:user_name=>"CTOLtest@user.com"}
          foro_group = {:user_group=>"Ctest@user.com", :permis=>"ctol"}
          foro_users = {:user_name=>"TOL2345", :user_email=>"subscription@email.com", :user_pass => Esp::User::FAKE_SECRET, :user_groups=>"Ctest@user.com", :user_style=>"ctol"}

          expect(Esp::Foro).to receive(:new).with(foro_user)
          expect(Esp::GroupForo).to receive(:new).with(foro_group)
          expect(Esp::Foro).to receive(:new).with(foro_users)

          @user.update(iscolectivo: true)
        end

        it 'do changes too for notaries users' do
          notaries = 1
          user = build_esp_user_with_consultant_and_without_collective(notaries)
          user.save
          foro_user = {:user_name=>"CTNTtest@user.com", :user_pass=>"change_password"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          user.update(password: 'change_password')
        end

        it 'do not changes when notaries users changes to not consultant' do
          notaries = 1
          user = build_esp_user_with_consultant_and_without_collective(notaries)
          user.save
          foro_user = {:user_name=>"CTNTtest@user.com", :user_pass=>"change_password"}

          expect(Esp::Foro).not_to receive(:new).with(foro_user)

          user.update(password: 'change_password', modulos: [])
        end

        it 'do not changes when notaries users changes to be collective' do
          notaries = 1
          user = build_esp_user_with_consultant_and_without_collective(notaries)
          user.save
          foro_user = {:user_name=>"CTNTtest@user.com", :user_pass=>"change_password"}

          expect(Esp::Foro).not_to receive(:new).with(foro_user)

          user.update(password: 'change_password', iscolectivo: true)
        end

        it 'deletes foro user when it is changed to no consultant' do
          @user.save
          foro_user = { :user_name => "CTOLtest@user.com" }

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [])

        end

        it 'deletes foro user, creates a foro group and moves all the subscriptions when changes to be collective' do
          subscription_id = 2345
          subscription_email = 'subscription@email.com'
          subscription = create(:user_subscription, id: subscription_id, perusuid: 'subscription@email.com', password: password)
          @user.save
          @user.update(user_subscriptions: [subscription])
          foro_user = {:user_name=>"CTOLtest@user.com"}
          foro_group = {:user_group=>"Ctest@user.com", :permis=>"ctol"}
          moved_subscription = {:user_name=>"TOL#{subscription_id}", :user_email=>subscription_email, :user_pass => Esp::User::FAKE_SECRET , :user_groups=>"Ctest@user.com", :user_style=>"ctol"}

          expect(Esp::Foro).to receive(:new).with(foro_user).once
          expect(Esp::GroupForo).to receive(:new).with(foro_group).once
          expect(Esp::Foro).to receive(:new).with(moved_subscription).once

          @user.update(iscolectivo: true)
        end
      end

      context "it hasn't consultant and is not collective" do
        before do
          @user = build_user_without_consultant_and_without_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'creates a foro user when it changes to has consultant' do
          @user.save
          foro_user = {:user_name=>"CTOLtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctol", :user_style=>"ctol"}

          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [esp_consultant_module])
        end

        it 'creates a foro group and adds all the users to it when changes to has consultant and with collective' do
          subscription_id = 2345
          subscription_email = 'subscription@email.com'
          subscription = create(:user_subscription, id: subscription_id, perusuid: 'subscription@email.com', password: password)
          @user.save
          @user.update(user_subscriptions: [subscription])
          foro_group = {:user_group=>"Ctest@user.com", :permis=>"ctol"}
          foro_user = {:user_name=>"TOL2345", :user_email=>subscription_email, :user_pass => Esp::User::FAKE_SECRET, :user_groups=>"Ctest@user.com", :user_style=>"ctol"}

          expect(Esp::GroupForo).to receive(:new).with(foro_group)
          expect(Esp::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [esp_consultant_module], iscolectivo: true)
        end
      end
    end

    context 'Mex' do
      context 'for not allowed subsystems' do
        before do
          @user = build_mex_non_tirant_user
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'does not do nothing when creates non TirantOnline users' do

          expect(Esp::GroupForo).not_to receive(:new)
          expect(Esp::Foro).not_to receive(:new)

          @user.save
        end

        it 'does not do nothing when deletes non TirantOnline users' do
          @user.save

          expect(Esp::GroupForo).not_to receive(:new)
          expect(Esp::Foro).not_to receive(:new)

          @user.destroy
        end

        it 'does not do nothing when changes non TirantOnline users' do
          @user.save

          expect(Esp::GroupForo).not_to receive(:new)
          expect(Esp::Foro).not_to receive(:new)

          @user.update(username: 'change_username')
        end
      end

      context 'it has consultant and is collective' do
        before do
          @user = build_mex_user_with_consultant_and_is_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'is created it creates a foro group' do
          foro_group = {:user_group=>"CMEXtest@user.com", :permis=>"ctolmex"}

          expect(Mex::GroupForo).to receive(:new).with(foro_group)

          @user.save
        end

        it 'deletes foro group when it is deleted' do
          @user.save
          foro_group = {:user_group=>"CMEXtest@user.com", :disable_users=>1}

          expect(Mex::GroupForo).to receive(:new).with(foro_group)

          @user.destroy
        end

        it 'changes foro users username when it is changed its username' do
          @user.save
          foro_group = {:group_name=>"CMEXtest@user.com", :new_group_name=>"CMEXchange_username"}

          expect(Mex::GroupForo).to receive(:new).with(foro_group)

          @user.update(username: 'change_username')
        end

        it 'moves users and deletes the group when changes to without consultant' do
          @user.save
          foro_users = {:user_group=>"CMEXtest@user.com", :user_groups=>"tolmex", :user_style=>"ctolmex"}
          foro_group = {:user_group=>"CMEXtest@user.com"}

          expect(Mex::GroupForo).to receive(:new).with(foro_users)
          expect(Mex::GroupForo).to receive(:new).with(foro_group)

          @user.update(modulos: [])
        end

        it 'moves foro users, deletes de foro group and creates foro user when changes to non collective' do
          @user.save
          foro_users = {:user_group=>"CMEXtest@user.com", :user_groups=>"tolmex", :user_style=>"ctolmex"}
          foro_group = {:user_group=>"CMEXtest@user.com"}
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctolmex", :user_style=>"ctolmex"}

          expect(Mex::GroupForo).to receive(:new).with(foro_users)
          expect(Mex::GroupForo).to receive(:new).with(foro_group)
          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(iscolectivo: false)
        end
      end

      context 'it has consultant and is not collective' do
        before do
          @user = build_mex_user_with_consultant_and_without_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'is created it creates a foro user' do
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctolmex", :user_style=>"ctolmex"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.save
        end

        it 'deletes foro user when it is deleted' do
          @user.save
          foro_user = {:user_name=>"CTOLMEXtest@user.com"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.destroy
        end

        it 'changes foro users username when it is changed its username' do
          @user.save
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :new_user_name=>"CTOLMEXchange_username"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(username: 'change_username')
        end

        it 'changes foro users password when it is changed its password' do
          @user.save
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :user_pass=>"change_password"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(password: 'change_password')
        end

        it 'changes foro users email when it is changed its email' do
          @user.save
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :user_email=>"change@email.com"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(email: 'change@email.com')
        end

        it 'deletes foro user, creates group and create users when it changes to be colective' do
          subscription_id = 2345
          subscription_email = 'subscription@email.com'
          @user.save
          subscription = create(:user_subscription_mex, id: subscription_id, perusuid: subscription_email, user: @user, password: password, subsystem: create(:subsystem_mex, id: 12345))
          @user.save
          @user.update(user_subscriptions: [subscription])
          foro_user = {:user_name=>"CTOLMEXtest@user.com"}
          foro_group = {:user_group=>"CMEXtest@user.com", :permis=>"ctolmex"}
          foro_users = {:user_name=>"TOLMEX#{subscription_id}", :user_email=>subscription_email, :user_pass => Esp::User::FAKE_SECRET, :user_groups=>"CMEXtest@user.com", :user_style=>"ctolmex"}

          expect(Mex::Foro).to receive(:new).with(foro_user)
          expect(Mex::GroupForo).to receive(:new).with(foro_group)
          expect(Mex::Foro).to receive(:new).with(foro_users)

          @user.update(iscolectivo: true)
        end

        it 'deletes foro user when it is changed to no consultant' do
          @user.save
          foro_user = { :user_name => "CTOLMEXtest@user.com" }

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [])
        end

        it 'deletes foro user, creates a foro group and moves all the subscriptions when changes to be collective' do
          subscription_id = 2345
          subscription_email = 'subscription@email.com'
          @user.save
          subscription = create(:user_subscription_mex, id: subscription_id, perusuid: 'subscription@email.com', user: @user, password: password, subsystem: create(:subsystem_mex, id: 12345))
          @user.update(user_subscriptions: [subscription])
          foro_user = {:user_name=>"CTOLMEXtest@user.com"}
          foro_group = {:user_group=>"CMEXtest@user.com", :permis=>"ctolmex"}
          moved_subscription = {:user_name=>"TOLMEX#{subscription_id}", :user_email=>subscription_email, :user_pass => Esp::User::FAKE_SECRET, :user_groups=>"CMEXtest@user.com", :user_style=>"ctolmex"}

          expect(Mex::Foro).to receive(:new).with(foro_user).once
          expect(Mex::GroupForo).to receive(:new).with(foro_group).once
          expect(Mex::Foro).to receive(:new).with(moved_subscription).once

          @user.update(iscolectivo: true)
        end
      end

      context "it hasn't consultant and is not collective" do
        before do
          @user = build_mex_user_without_consultant_and_without_collective
          @backoffice_user = create(:backoffice_user)
          @user.backoffice_user = @backoffice_user
        end

        it 'creates a foro user when it changes to has consultant' do
          @user.save
          foro_user = {:user_name=>"CTOLMEXtest@user.com", :user_email=>"test@user.com", :user_pass=>"12345678", :user_groups=>"ctolmex", :user_style=>"ctolmex"}

          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [mex_consultant_module])
        end

        it 'creates a foro group and adds all the users to it when changes to has consultant and with collective' do
          subscription_id = 2345
          subscription_email = 'subscription@email.com'
          subscription = create(:user_subscription_mex, id: subscription_id, perusuid: 'subscription@email.com', user: @user, password: password, subsystem: create(:subsystem_mex, id: 12345))
          @user.save
          @user.update(user_subscriptions: [subscription])
          foro_group = {:user_group=>"CMEXtest@user.com", :permis=>"ctolmex"}
          foro_user = {:user_name=>"TOLMEX2345", :user_email=>subscription_email, :user_pass => Esp::User::FAKE_SECRET, :user_groups=>"CMEXtest@user.com", :user_style=>"ctolmex"}

          expect(Mex::GroupForo).to receive(:new).with(foro_group)
          expect(Mex::Foro).to receive(:new).with(foro_user)

          @user.update(modulos: [mex_consultant_module], iscolectivo: true)
        end

        it "doesn't do nothing when it changes to be collective" do

          expect(Mex::GroupForo).not_to receive(:new)
          expect(Mex::Foro).not_to receive(:new)

          @user.update(iscolectivo: true)
        end
      end
    end
  end

  context 'before update' do
    it 'knows if it had consultant before update modules' do
      user = Esp::User.new(
        modulos: [esp_consultant_module],
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        email: 'test@user.com'
      )
      user.save

      user.update(modulos: [])

      expect(user.has_consultoria_before).to be_truthy
    end

    it "knows if it hadn't consultant before update modules" do
      user = Esp::User.new(
        modulos: [],
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        email: 'test@user.com'
      )
      user.save

      user.update(modulos: [esp_consultant_module])

      expect(user.has_consultoria_before).to be_falsy
    end

    it "knows if it has consultant before udpate it self" do
      user = Esp::User.new(
        modulos: [esp_consultant_module],
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        email: 'test@user.com',
        iscolectivo: true
      )
      user.save

      user.update(iscolectivo: false)

      expect(user.has_consultoria_before).to be_truthy
    end

    it "knows if it hasn't consultant before udpate it self" do
      user = Esp::User.new(
        modulos: [],
        access_type: access_type,
        user_type_group: user_type_group,
        subsystem: subsystem,
        access_type_tablet: access_type_tablet,
        password: '12345678',
        maxconexiones: 5,
        username: 'test@user.com',
        email: 'test@user.com',
        iscolectivo: true
      )
      user.save

      user.update(iscolectivo: false)

      expect(user.has_consultoria_before).to be_falsy
    end
  end

  describe '#iso_code' do
    context 'for Esp users' do
      it "returns 'es'" do
        user = create(:user)
        expect(user.iso_code).to eq('es')
      end
    end

    context 'for Mex users' do
      it "returns 'mx'" do
        user = create(:user_mex)
        expect(user.iso_code).to eq('mx')
      end
    end

    context 'for Latam users' do
      let(:pais_latam) { create(:pais_latam) }
      let(:user_latam) { create(:user_latam, subsystem: pais_latam.subsystem) }

      it 'returns country iso code by subsytem' do
        expect(user_latam.iso_code).to eq(pais_latam.codigo_iso_2digits)
      end
    end
  end

  describe '#dont_send_user_and_password' do
    let(:user) { build(:user) }

    it "is false when #send_user_and_password is nil" do
      user.send_user_and_password = nil
      expect(user.dont_send_user_and_password).to be_falsey
    end

    it "is false when #send_user_and_password is true" do
      user.send_user_and_password = true
      expect(user.dont_send_user_and_password).to be_falsey
    end

    it "is true when #send_user_and_password is false" do
      user.send_user_and_password = false
      expect(user.dont_send_user_and_password).to be_truthy
    end

    it "can be accessed via #attributes_and_permitted_attr_accessor" do
      expect(user.attributes_and_permitted_attr_accessor).to include('send_user_and_password')
    end

    describe '#send_welcome_email' do
      let(:user_mailer) {
        copy = double()
        allow(UserMailer).to receive(:with).and_return(copy)
        allow(copy).to       receive(:email_user_passwd).and_return(copy)
        copy
      }
      let(:send_welcome_email) { Esp::User.send_welcome_email(user,'es') }

      it "is sent when send_user_and_password is nil" do
        user.send_user_and_password = nil
        expect(user_mailer).to receive(:deliver_later)
        send_welcome_email
      end

      it "is sent when send_user_and_password is true" do
        user.send_user_and_password = true
        expect(user_mailer).to receive(:deliver_later)
        send_welcome_email
      end

      it "is not sent when send_user_and_password is false" do
        user.send_user_and_password = false
        expect(user_mailer).to_not receive(:deliver_later)
        send_welcome_email
      end
    end
  end


  describe '#has_offices_premium?' do
    let(:has_offices_premium) { user.send(:has_offices_premium?) }

    context 'for esp users' do
      let(:user) { esp_user(modulo_ids: modulo.id) }
      let(:modulo) { Esp::Modulo.create(id: modulo_id, nombre: 'Despachos premium') }

      context 'module_id is 10' do
        let(:modulo_id) { Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM }
        it { expect(has_offices_premium).to be_truthy }
      end

      context 'module_id is any other than 10' do
        let(:modulo_id) { Esp::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM + 1}
        it { expect(has_offices_premium).to be_falsey }
      end
    end

    context 'for mex users' do
      let(:user) { mex_user(modulo_ids: modulo.id) }
      let(:modulo) { Mex::Modulo.create(id: modulo_id, nombre: 'Despachos premium') }

      context 'module_id is 7' do
        let(:modulo_id) { Mex::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM }
        it { expect(has_offices_premium).to be_truthy }
      end

      context 'module_id is any other than 7' do
        let(:modulo_id) { Mex::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM + 1}
        it { expect(has_offices_premium).to be_falsey }
      end
    end


    context 'for latam users' do
      let(:user) { latam_user(modulo_ids: modulo.id) }
      let(:modulo) { Latam::Modulo.create(id: modulo_id, nombre: 'Despachos premium') }

      context 'module_id is 9' do
        let(:modulo_id) { Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM }
        it { expect(has_offices_premium).to be_truthy }
      end

      context 'module_id is any other than 9' do
        let(:modulo_id) { Latam::Modulo::MODULE_ID_GESTION_DESPACHOS_PREMIUM + 1}
        it { expect(has_offices_premium).to be_falsey }
      end
    end


  end

  def password
    '12345678'
  end

  def build_mex_user_with_consultant_and_is_collective
    consultant = create(:modulo_mex, id: 1)
    tirantonline = create(:subsystem_mex, id: 0)
    user = Mex::User.new(
      access_type: mex_access_type,
      user_type_group: mex_user_type_group,
      subsystem: tirantonline,
      access_type_tablet: mex_access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: true,
      email: 'test@user.com'
    )

    user
  end

  def build_mex_non_tirant_user
    consultant = create(:modulo_mex, id: 1)
    no_tirantonline = create(:subsystem_mex, id: 1)
    user = Mex::User.new(
      access_type: mex_access_type,
      user_type_group: mex_user_type_group,
      subsystem: no_tirantonline,
      access_type_tablet: mex_access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      email: 'test@user.com'
    )

    user
  end

  def build_esp_user_with_consultant_and_is_collective
    consultant = create(:modulo, id: 4)
    tirantonline = create(:subsystem, id: 0)
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: tirantonline,
      access_type_tablet: access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: true,
      email: 'test@user.com'
    )

    user
  end

  def build_esp_non_tirant_user
    consultant = create(:modulo, id: 4)
    no_tirantonline = create(:subsystem, id: 3)
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: no_tirantonline,
      access_type_tablet: access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      email: 'test@user.com'
    )

    user
  end

  def build_mex_user_with_consultant_and_without_collective(subsystem=0)
    consultant = create(:modulo_mex, id: 1)
    tirantonline = create(:subsystem_mex, id: subsystem)
    user = Mex::User.new(
      access_type: mex_access_type,
      user_type_group: mex_user_type_group,
      subsystem: tirantonline,
      access_type_tablet: mex_access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: false,
      email: 'test@user.com'
    )

    user
  end

  def build_mex_user_without_consultant_and_without_collective(subsystem=0)
    tirantonline = create(:subsystem_mex, id: subsystem)
    user = Mex::User.new(
      access_type: mex_access_type,
      user_type_group: mex_user_type_group,
      subsystem: tirantonline,
      access_type_tablet: mex_access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: false,
      email: 'test@user.com'
    )

    user
  end

  def build_user_without_consultant_and_without_collective(subsystem=0)
    tirantonline = create(:subsystem, id: subsystem)
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: tirantonline,
      access_type_tablet: access_type_tablet,
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: false,
      email: 'test@user.com'
    )

    user
  end

  def esp_consultant_module
    consultant_id = 4

    begin
      consultant = Esp::Modulo.find(consultant_id)
    rescue ActiveRecord::RecordNotFound
      consultant = create(:modulo, id: consultant_id)
    end

    consultant
  end

  def mex_consultant_module
    consultant_id = 1

    begin
      consultant = Mex::Modulo.find(consultant_id)
    rescue ActiveRecord::RecordNotFound
      consultant = create(:modulo_mex, id: consultant_id)
    end

    consultant
  end

  def build_esp_user_with_consultant_and_without_collective(subsystem=0)
    consultant = esp_consultant_module
    tirantonline = create(:subsystem, id: subsystem)
    user = Esp::User.new(
      access_type: access_type,
      user_type_group: user_type_group,
      subsystem: tirantonline,
      access_type_tablet: access_type_tablet,
      modulos: [consultant],
      password: '12345678',
      maxconexiones: 5,
      username: 'test@user.com',
      iscolectivo: false,
      email: 'test@user.com'
    )

    user
  end

  def response_user_personalizations
    {
      'result' => [
        StubUserPersonalization.new,
        StubUserPersonalization.new
      ],
      'total' => 2
    }
  end

  def esp_user(maxconexiones: 0, datelimit: DateTime.now, subid: 1, modulo_ids: nil)
    Esp::Modulo.create!(id: 9, nombre: 'Some module') if modulo_ids.nil?

    user = Esp::User.new(
      maxconexiones: maxconexiones,
      password: '12345678',
      email: 'esp@user.com',
      username: 'esp@user.com',
      access_type: Esp::AccessType.new(descripcion: 'AccessType description'),
      user_type_group: Esp::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion'),
      subsystem: Esp::Subsystem.new(id: subid, name: 'Subsystem'),
      access_type_tablet: Esp::AccessTypeTablet.new(descripcion: 'AccessTypeTablet description'),
      datelimit: datelimit,
      modulo_ids: modulo_ids
    )

    user.save
    user
  end

  def mex_user(maxconexiones: 0, datelimit: DateTime.now, subid: 1, modulo_ids: nil, independent_offices: false)
    Mex::Modulo.where(:id => 9).first || Mex::Modulo.create!(id: 9, nombre: 'Some module') if modulo_ids.nil?

    user = Mex::User.new(
      maxconexiones: maxconexiones,
      password: '12345678',
      email: 'mex@user.com',
      username: 'mex@user.com',
      access_type: Mex::AccessType.new(descripcion: 'AccessType description'),
      user_type_group: Mex::UserTypeGroup.where(:id => 1).first || Mex::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion'),
      subsystem: Mex::Subsystem.where(:id => subid).first || Mex::Subsystem.new(id: subid, name: 'Subsystem'),
      access_type_tablet: mex_access_type_tablet,
      datelimit: datelimit,
      modulo_ids: modulo_ids,
      independent_offices: independent_offices
    )

    user.save
    user
  end

  def mex_despacho_premium
    modulo = Mex::Modulo.where(:id => 7).first || Mex::Modulo.new(id: 7, nombre: 'Despacho Plus')
    modulo.save
    modulo
  end

  def mex_consultant_modulo
    modulo = Mex::Modulo.new(nombre: 'Consultant', id: Mex::Modulo.consultoria_ids[0])
    modulo.save

    modulo
  end

  def access_type
    access = Esp::AccessType.new(descripcion: 'AccessType description')
    access.save

    access
  end

  def mex_access_type
    access = Mex::AccessType.new(descripcion: 'AccessType description')
    access.save

    access
  end

  def latam_access_type
    access = Latam::AccessType.new(descripcion: 'AccessType description')
    access.save

    access
  end

  def user_type_group
    user = Esp::UserTypeGroup.where(:id => 1).first || Esp::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion')
    user.save

    user
  end

  def mex_user_type_group
    user = Mex::UserTypeGroup.where(:id => 1).first || Mex::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion')
    user.save

    user
  end

  def latam_user_type_group
    user = Latam::UserTypeGroup.where(:id => 1).first || Latam::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion')
    user.save

    user
  end

  def subsystem
    subsys = Esp::Subsystem.where(:id => 1).first || Esp::Subsystem.new(id: 1, name: 'Subsystem')
    subsys.save

    subsys
  end

  def mex_subsystem
    subsys = Mex::Subsystem.where(:id => 1).first || Mex::Subsystem.new(id: 1, name: 'Subsystem')
    subsys.save

    subsys
  end

  def latam_subsystem
    subsys = Latam::Subsystem.where(:id => 1).first || Latam::Subsystem.new(id: 1, name: 'Subsystem')
    subsys.save

    subsys
  end

  def access_type_tablet
    access = Esp::AccessTypeTablet.new(descripcion: 'AccessTypeTablet description')
    access.save

    access
  end

  def mex_access_type_tablet
    id = (Mex::AccessTypeTablet.first.try(:id) || 0)+1
    access = Mex::AccessTypeTablet.new(descripcion: 'AccessTypeTablet description', :id => id)
    access.save

    access
  end

  def latam_access_type_tablet
    id = (Latam::AccessTypeTablet.first.try(:id) || 0)+1
    access = Latam::AccessTypeTablet.new(descripcion: 'AccessTypeTablet description', :id => id)
    access.save

    access
  end

  def latam_user(maxconexiones: 0, datelimit: DateTime.now, subid: 1, modulo_ids: nil)
    Latam::Modulo.where(:id => 9).first || Latam::Modulo.create!(id: 9, nombre: 'Some module') if modulo_ids.nil?

    user = Latam::User.new(
      maxconexiones: maxconexiones,
      password: '12345678',
      email: 'latam@user.com',
      username: 'latam@user.com',
      access_type: Latam::AccessType.new(descripcion: 'AccessType description'),
      user_type_group: Latam::UserTypeGroup.where(:id => 1).first || Latam::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion'),
      subsystem: Latam::Subsystem.where(:id => subid).first || Latam::Subsystem.new(id: subid, name: 'Subsystem'),
      access_type_tablet: latam_access_type_tablet,
      datelimit: datelimit,
      modulo_ids: modulo_ids
    )

    user.save
    user
  end

  def any_subsystem
    create(:subsystem, id: 1)
  end

  class StubConnection
    def list(url, query_string = '')
      StubResource.new
    end

    def params_from(_)
    end
  end

  class StubResource
    def initialize
      @object = [StubOffice.new]
    end
    def error
    end

    def object
      @object
    end

    def total
      @object.count
    end
  end

  class StubOffice
    def reject
      {}
    end
  end

  class StubUserPersonalization
    def initialize
      @datelimit = ''
    end

    def datelimit
      @datelimit
    end

    def update(changes)
      @datelimit = changes[:datelimit]
    end
  end
end
