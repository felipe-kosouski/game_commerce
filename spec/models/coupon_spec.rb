# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).case_insensitive }

  it { should validate_presence_of(:status) }
  it { should define_enum_for(:status).with_values({ active: 1, inactive: 2 }) }

  it { should validate_presence_of(:due_date) }
  it { should validate_presence_of(:discount_value) }
  it { should validate_numericality_of(:discount_value).is_greater_than(0) }

  it "can't have past due_date" do
    subject.due_date = 1.day.ago
    subject.valid?
    expect(subject.errors.keys).to include :due_date
  end

  it "can't have due_date equal to current date" do
    subject.due_date = Time.zone.now
    subject.valid?
    expect(subject.errors.keys).to include :due_date
  end

  it 'is valid with future date' do
    subject.due_date = Time.zone.now + 1.day
    subject.valid?
    expect(subject.errors.keys).to_not include :due_date
  end

  it_behaves_like 'paginatable concern', :coupon
end
