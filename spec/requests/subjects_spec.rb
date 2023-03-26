require 'rails_helper'

describe 'Users Api', type: :request do
  let!(:subjects) { create_list(:subject, 3) }
  let!(:subsystems) { create_list(:subsystem, 2) }
  let(:subsystem_id) { subsystems.first.id }

  describe 'GET /subjects' do
    it 'returns subjects list' do
      get '/esp/subjects'

      expect(response).to have_http_status(200)
      expect(json['objects'].size).to eq(3)
    end

    context 'when search for a specific subject' do
      it 'returns the detail of the subject' do
        assing_subject_subsystem

        get '/esp/subjects', params: { subid: subsystem_id}

        expect(json['objects'].size).to eq(2)
      end
    end
  end

  def assing_subject_subsystem
    subjects.each_with_index do |subject, index|
      index < 2 ? subsystem = subsystems.first : subsystem = subsystems.last
      create(:subject_subsystem, :subject => subject, :subsystem => subsystem, :orden => index)
    end
  end
end

