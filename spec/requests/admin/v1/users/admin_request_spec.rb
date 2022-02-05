require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :admin', type: :request do
  let!(:login_user) { create(:user) }

  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let!(:users) { create_list(:user, 10) }

    before(:each) { get url, headers: auth_header(login_user) }

    it 'returns all users' do
      expect(body_json['users']).to contain_exactly(*User.all.as_json(only: %i[id name email profile]))
    end

    it 'returns success status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }

    context 'with valid params' do
      let(:user_params) { { user: attributes_for(:user) }.to_json }

      it 'adds a new user' do
        expect do
          post url, headers: auth_header(login_user), params: user_params
        end.to change(User, :count).by(1)
      end

      it 'returns last added user' do
        post url, headers: auth_header(login_user), params: user_params
        expected_user = User.last.as_json(only: %i[id name email profile])
        expect(body_json['user']).to eq(expected_user)
      end

      it 'returns success status' do
        post url, headers: auth_header(login_user), params: user_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) { { user: attributes_for(:user, name: nil) }.to_json }

      it 'does not add a new user' do
        expect do
          post url, headers: auth_header(login_user), params: user_invalid_params
        end.to_not change(User, :count)
      end

      it 'returns error messages' do
        post url, headers: auth_header(login_user), params: user_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable entity status' do
        post url, headers: auth_header(login_user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context 'with valid params' do
      let(:new_name) { 'Updated user name' }
      let(:user_params) { { user: { name: new_name } }.to_json }

      before(:each) { patch url, headers: auth_header(login_user), params: user_params }

      it 'updates a user' do
        user.reload
        expect(user.name).to eq new_name
      end

      it 'returns updated user' do
        user.reload
        expected_user = user.as_json(only: %i[id name email profile])
        expect(body_json['user']).to eq expected_user
      end

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) { { user: attributes_for(:user, name: nil) }.to_json }

      it 'does not update user' do
        old_user_name = user.name
        patch url, headers: auth_header(login_user), params: user_invalid_params
        user.reload
        expect(user.name).to eq old_user_name
      end

      it 'returns error messages' do
        patch url, headers: auth_header(login_user), params: user_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable entity status' do
        patch url, headers: auth_header(login_user), params: user_invalid_params
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'DELETE /users/:id' do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it 'removes a user' do
      expect do
        delete url, headers: auth_header(login_user)
      end.to change(User, :count).by(-1)
    end

    it 'does not reeturn any body content' do
      delete url, headers: auth_header(login_user)
      expect(body_json).to_not be_present
    end

    it 'returns no content status' do
      delete url, headers: auth_header(login_user)
      expect(response).to have_http_status :no_content
    end
  end
end
