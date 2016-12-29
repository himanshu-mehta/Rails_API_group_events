require 'rails_helper'

RSpec.describe User, type: :model do
	it "should have valid factory" do
	    FactoryGirl.build(:user).should be_valid
	end
end
