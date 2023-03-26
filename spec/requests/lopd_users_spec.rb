# frozen_string_literal: true

require "rails_helper"

describe "Users Lopd Api", type: :request do
  let!(:lopd_apps) { create_list(:lopd_app, 10) }
  let!(:lopd_ambitos) { lopd_apps.map { |app| create(:lopd_ambito, lopd_app: app) } }
  let!(:lopd_users) do
    Tirantid::LopdAmbito.all.map do |ambito|
      create_list(:lopd_user, 5, lopd_ambito: ambito)
    end
  end
  let!(:lopd_log_service) { Tirantid::LopdLogService.instance }

  describe "GET INDEX /lopd_users" do
    subject! do
      get "/esp/lopd_users", params: params
    end

    shared_examples "correct response with users" do
      it "returns status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns correct list of users" do
        expect(json["objects"].size).to eq(user_count)
      end
    end

    context "without params" do
      let(:params) {}

      include_examples "correct response with users" do
        let(:user_count) { 25 }
      end
    end

    context "with app name (ambito is default)" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 5 }
      end
    end

    context "with app name and ambito name" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 5 }
      end
    end

    context "with app name and ambito name and user external id" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre,
          usuario: lopd_apps.first.lopd_ambitos.last.lopd_users.first.usuario
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 1 }
      end
    end

    context "with app name and ambito name and user external id array" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre,
          usuarios: [lopd_apps.first.lopd_ambitos.last.lopd_users.first.usuario]
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 1 }
      end
    end

    context "with app name and ambito name and user external id array is nil" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre,
          usuarios: [nil]
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 0 }
      end
    end

    context "with app name and ambito name and user external id is nil" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre,
          usuario: nil
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 0 }
      end
    end

    context "with app name and ambito name and list from user external id" do
      let(:params) do
        {
          lopd_app: lopd_apps.first.nombre,
          lopd_ambito: lopd_apps.first.lopd_ambitos.last.nombre,
          usuarios: lopd_apps.first.lopd_ambitos.last.lopd_users.limit(3).map(&:usuario)
        }
      end

      include_examples "correct response with users" do
        let(:user_count) { 3 }
      end
    end
  end

  describe "GET SHOW /lopd_users/ID" do
    context "without params" do
      it "returns list of users" do
        get "/esp/lopd_users/%s" % Tirantid::LopdUser.first.id

        expect(response).to have_http_status(:ok)
        expect(json["resource"]).to eq(Tirantid::LopdUser.first.id)
      end
    end
  end

  describe "PUT /lopd_users/:id" do
    subject do
      put "/esp/lopd_users/#{lopd_user_id}", params: update_attributes
    end

    let(:lopd_user) { create(:lopd_user) }
    let(:lopd_user_id) { lopd_user.id }

    before do |example|
      subject unless example.metadata[:skip_subject]
    end

    shared_examples "must response 202" do
      it do
        expect(response).to have_http_status(:accepted)
      end
    end

    context "when it updates a lopd user" do
      context "with valid params" do
        let :update_attributes do
          {
            email: "new_email@host.com"
          }
        end

        it "must response 202" do
          log_file_last_line = lopd_log_service.get_ultima_linea.split(",")
          expect(log_file_last_line[0]).to eq(json["object"]["usuario"])
          expect(log_file_last_line[1]).to eq(lopd_user.lopd_ambito.lopd_app.nombre)
          expect(log_file_last_line[2]).to eq(lopd_user.lopd_ambito.nombre)
          expect(log_file_last_line[3]).to eq(Time.parse(json["object"]["updated_at"]).utc.iso8601.to_s)
          expect(log_file_last_line[4]).to eq("UPDATE")

          get "/esp/lopd_users/%s" % lopd_user_id

          expect(response).to have_http_status(:ok)
          expect(json["object"]["email"]).to eq("new_email@host.com")
        end

        include_examples "must response 202"
      end

      context "with invalid params inside lopd_user" do
        let(:update_attributes) do
          {
            lopd_user: { kk: "mola" }
          }
        end

        include_examples "must response 202"
      end

      context "without lopd_user param" do
        let(:update_attributes) {}

        include_examples "must response 202"
      end

      it "must response 404 with invalid id", skip_subject: true do
        put "/esp/lopd_users/kj", params: { locale: "en" }
        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Couldn't find Tirantid::LopdUser with 'id'=kj")
      end
    end
  end

  describe "POST #create/lopd_users" do
    context "create a new lopd user" do
      subject do
        post "/esp/lopd_users", params: valid_attributes
      end

      before do |example|
        subject unless example.metadata[:skip_subject]
      end

      context "with valid params with lopd_data_encoding" do
        let(:valid_attributes) do
          {
            lopd_data_encoding: "ISO-8859-1",
            lopd_app_name: lopd_apps.first.nombre,
            lopd_ambito_name: lopd_apps.first.lopd_ambitos.last.nombre,
            email: "test1@tirant.com",
            usuario: "sorianodepus",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel Soríano".encode("ISO-8859-1"),
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141",
            subid: 1
          }
        end

        it "must response 201" do
          expect(response).to have_http_status(:created)
          expect(json["object"]["nombre"]).to eq("Daniel Soríano")
          expect(json["object"]["subid"]).to eq(1)
        end
      end

      context "with valid params" do
        let(:valid_attributes) do
          {
            lopd_app_name: lopd_apps.first.nombre,
            lopd_ambito_name: lopd_apps.first.lopd_ambitos.last.nombre,
            email: "test1@tirant.com",
            usuario: "sorianodepus",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel",
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141"
          }
        end

        it "must response 201" do
          log_file_last_line = lopd_log_service.get_ultima_linea.split(",")
          expect(response).to have_http_status(:created)
          expect(json["object"]["email"]).to eq("test1@tirant.com")
          expect(json["object"]["usuario"]).to eq("sorianodepus")
          expect(json["object"]["comercial"]).to eq(true)
          expect(json["object"]["grupo"]).to eq(true)
          expect(json["object"]["privacidad"]).to eq(true)
          expect(log_file_last_line[0]).to eq("sorianodepus")
          expect(log_file_last_line[1]).to eq(valid_attributes[:lopd_app_name])
          expect(log_file_last_line[2]).to eq(valid_attributes[:lopd_ambito_name])
          expect(log_file_last_line[3]).to eq(Time.parse(json["object"]["updated_at"]).utc.iso8601.to_s)
          expect(log_file_last_line[4]).to eq("CREATE")

          get "/esp/lopd_users/%s" % json["object"]["id"]

          expect(response).to have_http_status(:ok)
          expect(json["resource"]).to eq(json["object"]["id"])
          expect(json["object"]["email"]).to eq("test1@tirant.com")
        end
      end

      context "without usuario: param" do
        let(:valid_attributes) do
          {
            lopd_app_name: lopd_apps.first.nombre,
            lopd_ambito_name: lopd_apps.first.lopd_ambitos.last.nombre,
            email: "soriano@tirant.com",
            usuario: "",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel",
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141",
            locale: "en"
          }
        end

        it "must response 422" do
          log_file_last_line = lopd_log_service.get_ultima_linea.split(",")
          expect(response).to have_http_status(:unprocessable_entity)
          body = JSON.parse(response.body)
          expect(body["message"]).to eq("Validation failed: Usuario can't be blank")
        end
      end

      context "with repatead usuario to same ambito" do
        let(:valid_attributes) do
          {
            lopd_app_name: lopd_apps.first.nombre,
            lopd_ambito_name: lopd_apps.first.lopd_ambitos.last.nombre,
            email: "test2@tirant.com",
            usuario: "sorianodepus",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel",
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141",
            locale: "en"
          }
        end

        it "must response 422", skip_subject: true do
          lopd_user = create(
            :lopd_user, lopd_ambito: lopd_apps.first.lopd_ambitos.last,
                        usuario: "sorianodepus"
          )
          post "/esp/lopd_users", params: valid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
          body = JSON.parse(response.body)
          expect(body["message"]).to eq("Validation failed: Usuario has already been taken")
        end
      end

      context "with app empty" do
        let(:valid_attributes) do
          {
            lopd_app_name: "",
            lopd_ambito_name: lopd_apps.first.lopd_ambitos.last.nombre,
            email: "test3@tirant.com",
            usuario: "sorianodepus3",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel",
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141",
            locale: "en"
          }
        end

        it "must response 422" do
          expect(response).to have_http_status(:not_found)
          body = JSON.parse(response.body)
          expect(body["message"])
            .to eq("Couldn't find Tirantid::LopdApp with [WHERE `lopd_apps`.`nombre` = ?]")
        end
      end

      context 'with ambito empty (ambito is "default")' do
        let(:valid_attributes) do
          {
            lopd_app_name: lopd_apps.first.nombre,
            lopd_ambito_name: "",
            email: "test3@tirant.com",
            usuario: "sorianodepus3",
            comercial: true,
            grupo: true,
            privacidad: true,
            nombre: "Daniel",
            notas: "Soriano de pus",
            telefono: "686645052",
            telefono2: "1414144",
            fax: "1414141"
          }
        end

        it "must response 201" do
          expect(response).to have_http_status(:created)
        end
      end
    end
  end
end
