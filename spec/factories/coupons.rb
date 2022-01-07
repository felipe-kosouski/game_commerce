# frozen_string_literal: true

FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique.promotion_code(digits: 6) }
    status { %i[active inactive].sample }
    discount_value { rand(1..99) }
    due_date { '2022-01-06 18:47:58' }
  end
end
