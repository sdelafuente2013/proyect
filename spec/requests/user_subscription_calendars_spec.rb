# frozen_string_literal: true

require "rails_helper"

describe "User Subscription Calendars", type: :request do
  before do
    create(:user_subscription_calendar_mex, id: "1", user_subscription_id: 3)
    create(:user_subscription_calendar_mex, id: "2", user_subscription_id: 3)
    create(:user_subscription_calendar_mex, id: "3", user_subscription_id: 1)
  end

  describe "GET /user_subscription_calendars/:id" do
    subject { get user_subscription_calendar_path("mex", id) }

    before { subject }

    context "with existing calendar id" do
      let(:id) { "1" }

      it "returns ok status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns calendar that matches request id" do
        expect(json["object"]["id"]).to eq("1")
      end

      it "returns calendar name" do
        expect(json["object"]["name"]).not_to be_empty
      end

      it "returns calendar type" do
        expect(json["object"]["type"]).not_to be_empty
      end

      it "returns calendar user subscription id" do
        expect(json["object"]["user_subscription_id"]).not_to be_blank
      end
    end

    context "with not existing calendar id" do
      let(:id) { "4" }

      it "returns not found status 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /user_subscription_calendars/" do
    subject { get user_subscription_calendars_path("mex", params) }

    before { subject }

    context "with user_subscription_id param" do
      let(:params) { { user_subscription_id: 3 } }

      it "returns only user_subscription calendars" do
        expect(json["objects"].length).to eq(2)
      end
    end

    context "with no params" do
      let(:params) { {} }

      it "returns all elements" do
        expect(json["objects"].length).to eq(3)
      end
    end
  end

  describe "POST /user_subscription_calendars/" do
    subject { post user_subscription_calendars_path("mex", params) }

    before { subject }

    context "with valid params" do
      let(:params) do
        {
          name: "calendario molón",
          type: "ics",
          user_subscription_id: 3
        }
      end

      it "returns created status 201" do
        expect(response).to have_http_status(:created)
      end

      it "returns new calendar id" do
        expect(json["object"]["id"]).not_to be_empty
      end

      it "saves calendar" do
        expect(Mex::UserSubscriptionCalendar.find(json["object"]["id"])).not_to be_blank
      end
    end
  end

  describe "PUT /user_subscription_calendars/:id" do
    subject { put user_subscription_calendar_path("mex", id, params) }

    before { subject }

    let(:params) do
      {
        name: "calendario molón 2",
        type: "data",
        events: [{ id: "1" }, { id: "2" }]
      }
    end

    context "with existing id" do
      let(:id) { "1" }

      it "returns ok status 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns updated name" do
        expect(json["object"]["name"]).to eq "calendario molón 2"
      end

      it "returns updated type" do
        expect(json["object"]["type"]).to eq "data"
      end

      it "returns updated events" do
        expect(json["object"]["events"]).to eq [{ "id" => "1" }, { "id" => "2" }]
      end

      it "updates calendar" do
        expect(Mex::UserSubscriptionCalendar.find(id).name).to eq "calendario molón 2"
      end
    end

    context "with not existing id" do
      let(:id) { "4" }

      it "returns not found status 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /user_subscription_calendars/:id" do
    subject { delete user_subscription_calendar_path("mex", id) }

    before { subject }

    context "with existing id" do
      let(:id) { "1" }

      it "returns no content status 204" do
        expect(response).to have_http_status(:no_content)
      end

      it "deletes calendar" do
        expect { Mex::UserSubscriptionCalendar.find(id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context "with not existing id" do
      let(:id) { "4" }

      it "returns not found status 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
