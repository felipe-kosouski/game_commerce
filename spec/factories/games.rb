# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    mode { %i[pvp pve both].sample }
    release_date { '2021-12-23 19:01:37' }
    developer { Faker::Company.name }
    system_requirement
  end
end
