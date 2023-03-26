require "rails_helper"

describe "User Subscription Api" do
  let(:default_subid) { 0 }
  let!(:subsystem) do
    Esp::Subsystem.where(id: default_subid).first || create(:subsystem, name: "Default Subsystem",
                                                                        id: default_subid)
  end
  let(:user) { create(:user) }
  let(:subscription) do
    create(:user_subscription,
           usuarioid: user.id,
           password: "mypassword",
           subid: default_subid)
  end

  before do
    allow(Esp::Foro).to receive(:new)
  end

  describe "POST /user_subscriptions/:id" do
    context "when the request is valid and it creates a new user subscription" do
      let(:valid_attributes) do
        {
          perusuid: "new_email@host.com",
          password: "password123",
          usuarioid: user.id
        }
      end

      before { post "/esp/user_subscriptions", params: valid_attributes }

      it "returns status code 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns the new user subscription object" do
        expect(json["object"]["perusuid"]).to eq("new_email@host.com")
      end
    end

    context "when the request is not valid because of the params" do
      shared_examples "invalid_fields" do
        before { post "/esp/user_subscriptions", params: invalid_params }

        it "returns status code 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns a validation failure message" do
          expect(response.body)
            .to include("Validation failed")
        end
      end

      describe "when the email is invalid" do
        it_behaves_like "invalid_fields" do
          let(:invalid_params) do
            {
              perusuid: "new_email@host",
              password: "password123",
              locale: "en"
            }
          end
        end
      end

      describe "when the password is invalid" do
        it_behaves_like "invalid_fields" do
          let(:invalid_params) do
            {
              perusuid: "new_email@host.com",
              password: "123",
              locale: "en"
            }
          end
        end
      end
    end
  end

  describe "GET /user_subscriptions" do
    before do
      subscription
    end

    context "returns the personalization list of a user" do
      before do
        get "/esp/user_subscriptions"
      end

      it "returns status code 422" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the subscription object" do
        expect(json["objects"].size).to eq(1)
      end
    end

    describe "GET /user_subscriptions/validate" do
      context "with wrong validation returns no personalization user" do
        let(:invalid_params) do
          {
            perusuid: subscription.perusuid,
            password: "NOTmypassword"
          }
        end

        before { get "/esp/user_subscriptions/validate", params: invalid_params }

        it "returns status code 200" do
          expect(response).to have_http_status(:ok)
        end

        it "does not return any object" do
          expect(json["objects"].size).to eq(0)
        end
      end

      context "with right validation" do
        describe "right validation without subid returns the personalization list of a user" do
          before do
            get "/esp/user_subscriptions/validate",
                params: { perusuid: subscription.perusuid, password: "mypassword" }
          end

          it "returns status code 200" do
            expect(response).to have_http_status(:ok)
          end

          it "returns list of objects" do
            expect(json["objects"].size).to eq(1)
          end

          it "returns valid perusuid" do
            expect(json["objects"][0]["perusuid"]).to eq subscription.perusuid
          end

          it "returns valid subscription id" do
            expect(json["objects"][0]["id"]).to eq subscription.id
          end
        end

        describe "right validation with subid returns a personalization user" do
          let(:default_subid) { 1 }

          before do
            get "/esp/user_subscriptions/validate",
                params: { perusuid: subscription.perusuid, password: "mypassword", subid: default_subid,
                          single: "true" }
          end

          it "returns status code 200" do
            expect(response).to have_http_status(:ok)
          end

          it "returns valid user id" do
            expect(json["object"]["id"]).to eq subscription.id
          end

          it "returns valid perusuid" do
            expect(json["object"]["perusuid"]).to eq subscription.perusuid
          end

          it "returns valid subscription id" do
            expect(json["object"]["subid"]).to eq subscription.subid
          end
        end
      end
    end
  end

  describe "POST /user_subscriptions/validate" do
    describe "right validation" do
      before do
        post "/esp/user_subscriptions/validate",
             params: { single: true, perusuid: subscription.perusuid, password: "mypassword",
                       subid: subscription.subid }
      end

      it "returns ok status" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an object" do
        expect(json["object"]).not_to eq({})
      end

      it "returns valid email" do
        expect(json["object"]["perusuid"]).to eq subscription.perusuid
      end

      it "returns valid user id" do
        expect(json["object"]["usuarioid"]).to eq user.id
      end
    end

    describe "wrong validation" do
      before do
        post "/esp/user_subscriptions/validate",
             params: { single: true, perusuid: subscription.perusuid, password: "NOTmypassword",
                       subid: subscription.subid }
      end

      it "returns ok status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an empty list" do
        expect(json).to eq({})
      end
    end
  end

  describe 'DELETE /user_subscriptions/:id' do
    before do
      create(:user_directory_esp, user_subscription: subscription)
    end

    context 'when specific a subscription to delete' do
      it 'returns status code 204' do
        delete "/esp/user_subscriptions/#{subscription.id}"

        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe "PUT /user_subscriptions/:id" do
    context "updates the user with the new email" do
      valid_attributes = { perusuid: "new_email@host.com" }

      before { put "/esp/user_subscriptions/#{subscription.id}", params: valid_attributes }

      it "returns updated email" do
        expect(json["object"]["perusuid"]).to eq("new_email@host.com")
      end
    end

    context "updates the newsletter" do
      valid_attributes = { enable_newsletter: false }

      before { put "/esp/user_subscriptions/#{subscription.id}", params: valid_attributes }

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns updated newsletter" do
        expect(json["object"]["news"]).to eq(false)
      end
    end

    it "creates a LOPD User when updates the User LOPD permission" do
      email = "dpo@email.com"
      first_name = "FirstName"
      last_name = "LastName"
      phonenumber = "987654321"
      comercial = true
      grupo = false
      privacidad = true
      subscription = create(:user_subscription, perusuid: email, nombre: first_name,
                                                apellidos: last_name, telefono: phonenumber, usuarioid: user.id)
      lopd_params = {
        comercial: comercial,
        grupo: grupo,
        privacidad: privacidad
      }

      put "/esp/user_subscriptions/#{subscription.id}", params: lopd_params

      lopd_user = Tirantid::LopdUser.find_by(usuario: subscription.id)
      expect(lopd_user.lopd_ambito.nombre).to eq("personalizacion")
      expect(lopd_user.subid).to eq(subscription.subid)
      expect(lopd_user.usuario).to eq(subscription.id.to_s)
      expect(lopd_user.email).to eq(subscription.perusuid)
      expect(lopd_user.nombre).to eq(subscription.nombre)
      expect(lopd_user.apellidos).to eq(subscription.apellidos)
      expect(lopd_user.fax).to be_nil
      expect(lopd_user.telefono).to eq(subscription.telefono)
      expect(lopd_user.comercial).to eq(comercial)
      expect(lopd_user.grupo).to eq(grupo)
      expect(lopd_user.privacidad).to eq(privacidad)
    end
  end

  describe "GET /user_subscriptions" do
    context "when search by email returns the list of the user subscriptions" do
      before { get "/esp/user_subscriptions", params: { perusuid: subscription.perusuid } }

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end

      it "return the subscription object" do
        expect(json["total"]).to eq(1)
      end
    end
  end

  describe "request recover password" do
    subject do
      post request_recover_password_user_subscriptions_path(
        tolgeo: "esp",
        email: "email@example.com",
        change_password_url: "foo",
        subid: "0"
      )
    end

    before do
      allow(UserSubscription::RequestRecoverPassword).to receive(:call).and_return nil
      subject
    end

    it "calls the service" do
      expect(UserSubscription::RequestRecoverPassword)
        .to have_received(:call)
        .with("esp", "email@example.com", "foo", "0")
    end

    it "does not return any status" do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "change password" do
    subject do
      post change_password_user_subscriptions_path(
        tolgeo: "esp",
        token: "foo",
        password: "bar"
      )
    end

    let(:user_subscription) { instance_double(Esp::UserSubscription) }
    let(:user_subscription_valid) { true }
    let(:user_subscription_errors) { nil }

    shared_examples "calls change password service" do
      it do
        expect(UserSubscription::ChangePassword)
          .to have_received(:call)
          .with("esp", "foo", "bar")
      end
    end

    context "with valid token" do
      before do
        allow(UserSubscription::ChangePassword).to receive(:call).and_return user_subscription
        allow(user_subscription).to receive(:valid?).and_return user_subscription_valid
        allow(user_subscription).to receive(:errors).and_return user_subscription_errors

        subject
      end

      context "and password" do
        let(:user_subscription_valid) { true }

        include_examples "calls change password service"

        it "does not return any status" do
          expect(response).to have_http_status(:no_content)
        end
      end

      context "but invalid password" do
        let(:user_subscription_valid) { false }
        let(:user_subscription_errors) do
          ActiveModel::Errors.new({}).tap { |obj| obj.add(:base, "errors") }
        end

        include_examples "calls change password service"

        it "returns error message" do
          expect(JSON.parse(response.body)["message"]).to eq "errors"
        end

        it "returns unprocessable entity error" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "with invalid token" do
      before do
        allow(UserSubscription::ChangePassword)
          .to receive(:call)
          .and_raise UserSubscription::ChangePassword::InvalidToken

        subject
      end

      include_examples "calls change password service"

      it "returns invalid token error message" do
        expect(JSON.parse(response.body)["message"])
          .to eq I18n.t("controllers.users_subscriptions.invalid_token")
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "update email" do
    subject do
      post change_email_user_subscriptions_path(
        tolgeo: "esp",
        new_email: new_email,
        id: user_subscription2.id
      )
      user_subscription2.reload
    end

    let(:user_subscription2) { create(:user_subscription) }
    let(:new_email) { "correonuevo@tirat.com" }
    let(:user_subscription_errors) { nil }

    it do
      expect { subject }
        .to change(user_subscription2, :perusuid)
        .to new_email
    end
  end

  context "creates a subscription" do
    describe "with access type tablet" do
      let(:access_type_tablet) do
        create(:access_type_tablet, id: 2)
      end

      let(:user) do
        create(:user, access_type_tablet: access_type_tablet)
      end

      it "allows tablet access if its owner allows to all subscriptions" do
        creation_params = {
          "password" => "123456789",
          "perusuid" => "user@subscription.com",
          "usuarioid" => user.id
        }

        post "/esp/user_subscriptions", params: creation_params

        expect(json["object"]["acceso_tablet"]).to eq(true)
        expect(json["object"]["fecha_alta_tablet"]).not_to be_empty
      end
    end

    it "with a directory" do
      creation_params = {
        "password" => "123456789",
        "perusuid" => "user@subscription.com",
        "usuarioid" => user.id
      }

      post "/esp/user_subscriptions", params: creation_params

      directory = Esp::UserDirectory.find_by(persubscription_id: json["object"]["id"])
      expect(directory).not_to be_nil
    end
  end

  describe "search all cases by user_subscription" do
    let!(:user_subscription1) { create(:user_subscription) }
    let!(:user_subscription_cases_by_user_subscription) do
      create_list(:esp_user_subscription_case, 2, namecase: "pruebaporid",
                                                  user_subscription_id: user_subscription1.id)
    end
    let!(:user_subscription_empty) { create(:user_subscription) }

    context "when user_subscription has cases" do
      before(:context) do
        Esp::UserSubscriptionCase.destroy_all
        Esp::UserSubscription.destroy_all
      end

      it "return cases" do
        user_subscription_by_cases = user_subscription1.cases.to_a
        expect(user_subscription_by_cases[0]["namecase"]).to eq("pruebaporid")
        expect(user_subscription_by_cases.size).to eq(2)
      end

      it "return empty" do
        user_subscription_by_cases = user_subscription_empty.cases.to_a
        expect(user_subscription_by_cases.size).to eq(0)
      end
    end
  end
end
