require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  it { should belong_to(:product) } 
  it { should belong_to(:category) } 
end
