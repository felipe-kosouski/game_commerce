# frozen_string_literal: true

class Coupon < ApplicationRecord
  validates_presence_of :code, presence: true
  validates_uniqueness_of :code, case_sensitive: false
  validates_presence_of :status, presence: true
  validates_presence_of :due_date, presence: true
  validates_presence_of :discount_value, presence: true
  validates_numericality_of :discount_value, greater_than: 0

  validates :due_date, presence: true, future_date: true
  enum status: { active: 1, inactive: 2 }
end
