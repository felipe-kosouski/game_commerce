# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    before(:each) { get url, headers: auth_header(user) }

    it 'returns all system_requirements' do
      expect(body_json['system_requirements']).to contain_exactly(*system_requirements.as_json(only: %i[id name
                                                                                                        operational_system storage processor memory video_board]))
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }

    context 'with valid params' do
      let(:requirement_params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it 'adds a new system requirement' do
        expect do
          post url, headers: auth_header(user), params: requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it 'returns last added system requirement' do
        post url, headers: auth_header(user), params: requirement_params
        expected_requirement = SystemRequirement.last.as_json(only: %i[id name operational_system storage processor
                                                                       memory video_board])
        expect(body_json['system_requirement']).to eq(expected_requirement)
      end

      it 'returns success status' do
        post url, headers: auth_header(user), params: requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, operational_system: nil) }.to_json
      end

      it 'does not add a new system requirement' do
        expect do
          post url, headers: auth_header(user), params: requirement_invalid_params
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(user), params: requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('operational_system')
      end

      it 'returns unprocessable entity status' do
        post url, headers: auth_header(user), params: requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context 'with valid params' do
      let(:new_operational_system) { 'Hackintosh Xablau' }
      let(:requirement_params) { { system_requirement: { operational_system: new_operational_system } }.to_json }

      before(:each) { patch url, headers: auth_header(user), params: requirement_params }

      it 'updates a system requirement' do
        system_requirement.reload
        expect(system_requirement.operational_system).to eq new_operational_system
      end

      it 'returns updated system requirement' do
        system_requirement.reload
        expected_system_requirement = system_requirement.as_json(only: %i[id name operational_system storage processor
                                                                          memory video_board])
        expect(body_json['system_requirement']).to eq expected_system_requirement
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, operational_system: nil) }.to_json
      end

      it 'does not update system requirement' do
        old_operation_system = system_requirement.operational_system
        patch url, headers: auth_header(user), params: requirement_invalid_params
        system_requirement.reload
        expect(system_requirement.operational_system).to eq old_operation_system
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user), params: requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('operational_system')
      end

      it 'returns unprocessable entity status' do
        patch url, headers: auth_header(user), params: requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /system_requirements/:id' do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context 'without associated game' do
      it 'removes system requirement' do
        expect do
          delete url, headers: auth_header(user)
        end.to change(SystemRequirement, :count).by(-1)
      end

      it 'does not return any body content' do
        delete url, headers: auth_header(user)
        expect(body_json).to_not be_present
      end

      it 'returns no content status' do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with associated game' do
      before(:each) do
        create(:game, system_requirement: system_requirement)
      end

      it 'does not remove system requirement' do
        expect do
          delete url, headers: auth_header(user)
        end.to_not change(SystemRequirement, :count)
      end

      it 'returns unprocessable entity' do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
