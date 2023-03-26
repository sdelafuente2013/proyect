# frozen_string_literal: true

require "rails_helper"

describe "lopd htm api", type: :request do
  subject! { post lopd_texts_path(tolgeo: "esp", locale: locale) }

  let(:locale) { "es" }

  context "when service has success" do
    it "returns service response as the body" do
      expect(JSON.parse(response.body)["object"]).to eq(
        { content: I18n.t("lopd", locale: locale) }.deep_stringify_keys
      )
    end

    it { expect(response).to have_http_status(:ok) }
  end
end
