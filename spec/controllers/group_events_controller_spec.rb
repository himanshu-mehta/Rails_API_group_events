require 'rails_helper'

RSpec.describe GroupEventsController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }

	it "soft delete group event" do
		event = user.group_events.build(:duration => 3)
		event.save
		event.destroy
		expect(event).to be_present
	end
end
