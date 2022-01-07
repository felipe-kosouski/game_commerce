# frozen_string_literal: true

FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operational_system { Faker::Computer.os }
    storage { '500gb' }
    processor { 'AMD Ryzen 5' }
    memory { '8gb' }
    video_board { 'GTX 1060' }
  end
end
