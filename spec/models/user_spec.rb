# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:profile) }
  it { should define_enum_for(:profile).with_values({ admin: 0, client: 1 }) }

  it_behaves_like 'name searchable concern', :user
  # it_behaves_like 'paginatable concern', :user
end
