# frozen_string_literal: true

require "rails_helper"

describe "Users Api", type: :request do
  let!(:modulos) { create_list(:modulo, 3) }
  let!(:subsystems) { create_list(:subsystem, 2) }
  let(:subsystem_id) { subsystems.first.id }

  describe "GET /modulos" do
    before do
      get "/esp/modulos"
    end

    it "returns a valid response" do
      expect(response).to have_http_status(:ok)
    end

    it "returns the list of modules" do
      expect(json["objects"].size).to eq(3)
    end

    context "when search for a specific module" do
      it "returns the detail of the module" do
        assing_module_subsystem

        get "/esp/modulos", params: { subid: subsystem_id }

        expect(json["objects"].size).to eq(2)
      end
    end

    context "when search for a premium module" do
      before do
        premium_subsystem = create(:subsystem)
        premium_module = create(:modulo)
        create(:modulo)
        Esp::ModuloPremiumSubsystem.create(modulo: premium_module, subsystem: premium_subsystem)
        params = { premium_subid: premium_subsystem.id }

        get "/esp/modulos/", params: params
      end

      it "retrieves premium modules" do
        expect(json["total"]).to eq(1)
      end
    end
  end

  def assing_module_subsystem
    modulos.each_with_index do |modulo, index|
      subsystem = index < 2 ? subsystems.first : subsystems.last
      create(:modulo_subsystem, modulo: modulo, subsystem: subsystem, orden: index)
    end
  end
end
