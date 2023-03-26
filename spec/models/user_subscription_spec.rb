# frozen_string_literal: true

require "rails_helper"

describe "UserSubscription" do
  let(:user) { create(:user) }

  before do
    allow(Esp::Foro).to receive(:new)
    @another_subsystem =
      Esp::Subsystem.where(id: 0).first ||
      create(:subsystem, name: "Another Subsystem", id: 0)
  end

  shared_examples "set attributes correctly" do
    it "set presubscription" do
      expect(subject.persubscription_id).to eq(subscription.id)
    end

    it "set type correctly" do
      expect(subject.type).to eq(type_id)
    end
  end

  include_examples "user subscription password management"

  describe "can be created" do
    subject { user_subscription.save }

    let(:user_subscription) do
      Esp::UserSubscription.new(
        perusuid: email,
        password: password,
        usuarioid: user.id
      )
    end

    it "creates an user subscription" do
      is_expected.to eq true
    end
  end

  describe "can fill creation date" do
    let(:right_now) { Time.now.utc }

    it "fills creation date correctly" do
      user_subscription = Esp::UserSubscription.new(
        perusuid: email,
        password: password,
        usuarioid: user.id
      )
      user_subscription.save
      expect((user_subscription.creation_date - right_now).abs).to be < 10
    end
  end

  describe "has 'lang' attribute" do
    subject { user_subscription.save }

    let(:user_subscription) do
      Esp::UserSubscription.new(
        perusuid: email,
        password: password,
        usuarioid: user.id
      )
    end

    it "has lang attribute" do
      expect(user_subscription).to have_attribute(:lang)
    end
  end

  describe "user_subscription set password attributes" do
    subject { user_subscription.save }

    let(:user) { create(:user, add_perso_account: true) }
    let(:attributes) do
      {
        password: password,
        perusuid: "user@subscription.com",
        usuarioid: user.id
      }
    end
    let(:user_subscription) { Esp::UserSubscription.create!(attributes) }

    it "sets password_digest correctly" do
      expect(user_subscription.password_digest).to be_truthy
    end

    it "sets password_salt attribute correctly" do
      expect(user_subscription.password_salt).to be_truthy
    end

    it "encrypts correctly" do
      expect(
        user_subscription.password_digest ==
        Digest::SHA2.hexdigest(user_subscription.password_salt + attributes[:password])
      ).to be_truthy
    end
  end

  describe "user subscription set tablet access attribute" do
    subject { Esp::UserSubscription.create!(attributes) }

    let(:access_type_tablet_allowed_by_domain) { create(:access_type_tablet, id: 3) }
    let(:attributes) do
      {
        password: password,
        perusuid: "user@subscription.com",
        usuarioid: user.id
      }
    end

    context "when owner allows it to all its subscriptions" do
      let(:access_type_tablet_allowed) { create(:access_type_tablet, id: 2) }
      let(:user) { create(:user, access_type_tablet: access_type_tablet_allowed) }

      it "has tablet access" do
        expect(subject.acceso_tablet).to be_truthy
      end

      it "has tablet access date" do
        expect(subject.fecha_alta_tablet).not_to be_nil
      end
    end

    context "when owner does't allow it to all its subscriptions" do
      let(:access_type_tablet_not_allowed) { create(:access_type_tablet, id: 1) }
      let(:user) { create(:user, access_type_tablet: access_type_tablet_not_allowed) }

      it "dont have tablet access" do
        expect(subject.acceso_tablet).to be_falsy
      end

      it "dont have tablet access date" do
        expect(subject.fecha_alta_tablet).to be_nil
      end
    end

    describe "owner allow tablet access by domain" do
      let(:user) do
        create(
          :user,
          access_type_tablet: access_type_tablet_allowed_by_domain,
          dominios: "@subscription, @another"
        )
      end

      context "when domain is allowed" do
        let(:attributes) do
          {
            password: password,
            perusuid: "user@subscription.com",
            usuarioid: user.id
          }
        end

        it "dont have tablet access" do
          expect(subject.acceso_tablet).to be_truthy
        end

        it "dont have tablet access date" do
          expect(subject.fecha_alta_tablet).not_to be_nil
        end
      end

      context "when domain is not allowed" do
        let(:attributes) do
          {
            password: password,
            perusuid: "no@domain.com",
            usuarioid: user.id
          }
        end

        it "dont have tablet access" do
          expect(subject.acceso_tablet).to be_falsy
        end

        it "dont have tablet access date" do
          expect(subject.fecha_alta_tablet).to be_nil
        end
      end
    end

    describe "add directories" do
      subject { Esp::UserDirectory.find_by(user_subscription: subscription.id, type: type_id) }

      let(:attributes) do
        {
          password: password,
          perusuid: "user@subscription.com",
          usuarioid: user.id
        }
      end
      let(:subscription) { Esp::UserSubscription.create!(attributes) }

      context "when type id is document" do
        let(:type_id) { 0 }

        include_examples "set attributes correctly"
      end

      context "when type id is index" do
        let(:type_id) { 1 }

        include_examples "set attributes correctly"
      end

      context "when type id is search" do
        let(:type_id) { 2 }

        include_examples "set attributes correctly"
      end
    end
  end

  describe "add Foros" do
    

    context "with Esp tolgeo" do
      let(:subsys_analytics) { create(:subsystem, id: 4, name: "analytics") }
      let(:subscription) do
        create(
          :user_subscription_with_fake_password,
          usuarioid: user.id,
          subid: subsys_analytics.id
        )
      end

      it "does not create an account for analytics user" do
        expect(Esp::Foro).not_to have_received(:new)
        subscription.save
      end

      context "with non analytics user" do
        let(:subsystem_non_analytics_esp) do
          Esp::Subsystem.where(id: 0).first || create(:subsystem, name: "TOL", id: 0)
        end
        let(:account_with_a_group) do
          foro_account_with("TOL#{subscription_with_non_analytics_user.id}")
        end
        let(:subscription_with_non_analytics_user) do
          Esp::UserSubscription.new(
            id: subscription_id,
            perusuid: email,
            password: password,
            usuarioid: user.id,
            subid: subsystem_non_analytics_esp.id
          )
        end

        it "creates an account with a group for a non analytics user" do
          expect(Esp::Foro).to receive(:new).with(account_with_a_group)
          subscription_with_non_analytics_user.save
        end
      end

      context "with two groups for a non analytics user with consultant and being collective" do
        let(:consultoria) { create(:modulo, id: 4) }
        let(:non_analytics) { create(:subsystem, id: 2) }
        let(:user) { create(:user, iscolectivo: true, modulos: [consultoria]) }
        let(:subscription_with_non_analytics_consultant_and_is_collective_user) do
          Esp::UserSubscription.new(
            id: subscription_id,
            perusuid: email,
            password: password,
            usuarioid: user.id,
            subid: non_analytics.id
          )
        end
        let(:two_groups) {
          "tase,C#{subscription_with_non_analytics_consultant_and_is_collective_user.user.username}"
        }
        let(:account_with_two_groups) { foro_account_with("TAS1234", two_groups, "ctol") }

        it "creates foro with two groups" do
          expect(Esp::Foro).to receive(:new).with(account_with_two_groups)
          subscription_with_non_analytics_consultant_and_is_collective_user.save
        end
      end
    end

    context "with Mex tolgeo" do
      let(:account_with_a_group) do
        foro_account_with("TOLMEX#{subscription_id}", "tolmex", "ctolmex")
      end
      let(:non_analytics_subsystem_mex) { create(:subsystem_mex, name: "TOL", id: 0) }
      let(:user_mex) { create(:user_mex, subid: non_analytics_subsystem_mex.id) }
      let(:subscription_with_non_analytics_consultant_and_is_collective_user) do
        Mex::UserSubscription.new(
          id: subscription_id,
          perusuid: email,
          password: password,
          usuarioid: user_mex.id,
          subid: non_analytics_subsystem_mex.id
        )
      end

      it "creates an account with a group for a user" do
        expect(Mex::Foro).to receive(:new).with(account_with_a_group)
        subscription_with_non_analytics_consultant_and_is_collective_user.save
      end
    end
  end

  def foro_account_with(username, groups = "tol", style = "ctol")
    {
      user_name: username,
      user_email: email,
      user_pass: "fakePass",
      user_groups: groups,
      user_style: style
    }
  end

  def email
    "an@email.com"
  end

  def password
    "12345678"
  end

  def subscription_id
    1234
  end
end
