# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should belong_to :productable }

  it { should have_many(:product_categories).dependent(:destroy) }
  it { should have_many(:categories).through(:product_categories) }

  it { should validate_presence_of(:image) }
end
