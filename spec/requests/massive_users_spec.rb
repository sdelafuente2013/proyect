require 'rails_helper'

describe 'Massive Users' do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let(:locale_send_mail) { 'es' }
  let(:locale) { 'es' }
  let(:massive_users_params) {
    {
      locale: locale,
      locale_send_mail: locale_send_mail,
      user_candidates: [new_user, user_without_email],
      permisos: '',
      maxconexiones: 10
      }.merge(common_user_attrs)
  }
  let(:massive_users_post) { post '/esp/massive_users', params: massive_users_params }
  let(:job) { }

  it 'enques one job' do
    expect { massive_users_post }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'enques a MassiveUsersJob job' do
    expect { massive_users_post }.to have_enqueued_job(MassiveUsersJob)
  end

  describe MassiveUsersJob do
    let(:locale_send_mail) { 'pt' }

    before do
      allow(MassiveUsersJob).to receive(:perform_later) { |*args|
        MassiveUsersJob.perform_now(*args)
      }
    end

    it 'expect execute import users with right locale' do
      expect(Esp::User).to receive(:import_users).with(any_args,'pt')
      massive_users_post
    end

  end


  def new_user
    { nombre: 'NewUser', email: 'new@user.com', usuario: 'newusuario', password: '123456789' }
  end

  def user_without_email
   { nombre: 'UserWithoutEmail', usuario: 'userwithoutemail', password: '123456789' }
  end

  def common_user_attrs
    {tipoaccesoid: access_type,
    tipousuariogrupoid: user_type_group,
    subid: subsystem,
    tipoaccesotabletid: access_type_tablet,
    grupoid: group}
  end

  def access_type
    access = Esp::AccessType.new(descripcion: 'AccessType description')
    access.save

    access.id
  end

  def user_type_group
    user = Esp::UserTypeGroup.where(:id => 1).first || Esp::UserTypeGroup.new(id: 1, descripcion: 'UserTypeGroup descripcion')
    user.save

    user.id
  end

  def subsystem
    subsys = Esp::Subsystem.where(:id => 1).first || Esp::Subsystem.new(id: 1, name: 'Subsystem')
    subsys.save

    subsys.id
  end

  def access_type_tablet
    access = Esp::AccessTypeTablet.new(descripcion: 'AccessTypeTablet description')
    access.save

    access.id
  end

  def group
    group = Esp::Group.new(descripcion: 'Group description',  tipoid: user_type_group)
    group.save
    group.id
  end
end
