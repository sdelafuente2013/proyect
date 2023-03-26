# frozen_string_literal: true

require "rails_helper"

RSpec.describe Esp::CommercialContact do

  let(:commercial_contact) { build(:commercial_contact) }

  before do
    create_or_return_subsytem_tol(1)
    create_or_return_subsytem_tol(2)
    create_or_return_subsytem_tol(3)
    FactoryBot.create(:commercial_contact, :subid => 1, :id => 12, :email => "pepito@tirant.com" , :origen => "Popup Demo",:fecha_alta =>Date.parse("2020-03-10 17:09:26") )
    FactoryBot.create(:commercial_contact, :subid => 2, :id => 45, :email => "juanito@tirant.com", :origen => "Banner Editorial",:fecha_alta =>Date.parse("2020-03-10 17:09:26"))
    FactoryBot.create(:commercial_contact, :subid => 2, :id => 99, :email => "pepito@tirant.com", :origen => "Popup Demo",:fecha_alta =>Date.parse("2019-03-10 17:09:26"))
    FactoryBot.create(:commercial_contact, :subid => 3, :id => 32, :email => "pepito@tirant.com", :origen => "Banner Libreria", :fecha_alta =>Date.parse("2017-03-10 17:09:26"))
    FactoryBot.create(:commercial_contact, :subid => 3, :id => 22, :email => "juanito@tirant.com", :origen => "Anuncio", :fecha_alta =>Date.parse("2020-03-12 17:09:26"))
  end

  it ' is instantiable' do
    expect { commercial_contact = Esp::CommercialContact.new }.not_to raise_error
  end

  it ' has a valid factory' do
    expect(commercial_contact).to be_valid
  end


  describe "ActiveModel validations" do
    it 'includes the presence of all mandatory attributes' do
       expect(commercial_contact).to validate_presence_of(:nombre)
       expect(commercial_contact).to validate_presence_of(:apellidos)
       expect(commercial_contact).to validate_presence_of(:telefono)
       expect(commercial_contact).to validate_presence_of(:email)
       expect(commercial_contact).to validate_presence_of(:subid)
    end
  end


  describe "When a commercial contact is created" do
    context "with empty params" do
      before do
        empty_params = {}
        @commercial_contact = Esp::CommercialContact.new(empty_params)
      end

      it "the commercial contact created is falsey" do

        result = @commercial_contact.save

        expect(result).to be_falsey
      end
    end

    context "with valid params" do
      let(:email) { "mail@prueba1.com" }
      let(:name) { "John" }

      subject do
        described_class.create(
          nombre: name,
          apellidos: 'Doe Moe',
          email: email,
          telefono: "662662662",
          codigo_postal: "46014",
          fecha_alta: DateTime.now,
          origen: "Popup",
          subid: 2,
          id_usuario: "1234",
          lopd_privacidad: true
        )
      end

      it "the commercial contact is created rightly" do
        is_expected.to be_truthy
      end

      describe "creates a lopd user" do
        it { expect { subject }.to change(Tirantid::LopdUser, :count).by 1 }

        it do
          subject

          expect(Tirantid::LopdUser.last.email).to eq email
        end
      end

      context "when there are a commercial contact with same email" do
        before { create :commercial_contact, email: email }

        describe "updates a lopd user" do
          it { expect { subject }.not_to change(Tirantid::LopdUser, :count) }

          it do
            subject

            expect(Tirantid::LopdUser.find_by(email: email).nombre).to eq name
          end
        end
      end
    end
  end

  RSpec.shared_examples "search is called" do |result, params|

    it "with params #{params.to_json} must result #{result}" do
      expect(Esp::CommercialContact.search(params).pluck(:id)).to eq(result)
    end
  end

  describe '#Search' do
    it_behaves_like "search is called", [12],  {"subid":1}
    it_behaves_like "search is called", [45,99],  {"subid":2}
    it_behaves_like "search is called", [22,32],  {"subid":3}
    it_behaves_like "search is called", [12,32,99],  {"email": "pepito@tirant.com"}
    it_behaves_like "search is called", [22,45],  {"email": "juanito@tirant.com"}
    it_behaves_like "search is called", [12,99],  {"origin": "Popup Demo"}
    it_behaves_like "search is called", [32],  {"origin": "Banner Libreria"}
    it_behaves_like "search is called", [22],  {"origin": "Anuncio"}
    it_behaves_like "search is called", [12,45], {"fecha_alta_start": "01/03/2020","fecha_alta_end": "11/03/2020"}
  end


end
