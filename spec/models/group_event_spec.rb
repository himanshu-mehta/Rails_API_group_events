require 'rails_helper'

describe GroupEvent, type: :model do
	let(:user) { FactoryGirl.create(:user) }

	it { should belong_to(:user) }

	it "doesn't create event if no user is given" do
	    event = GroupEvent.create
	    expect(event).to be_invalid
	end

	it "doesn't create event if no duration is given" do
	    event = user.group_events.build
	    expect(event.save).to be_falsey
	end

	it "doesn't allow non-integer value for duration attribute" do
	    event = user.group_events.build(:duration => "string")
	    expect(event.save).to be_falsey
	end

	it "allow integer value for duration attribute" do
	    event = user.group_events.build(:duration => 3)
	    expect(event.save).to be_truthy
	end

	it do should validate_numericality_of(:duration).
                 on(:create)
    end

	it do should validate_numericality_of(:duration).
                 on(:update)
    end

	it do should validate_numericality_of(:duration).
                 on(:update)
    end

	it "runs is_publishable after validations on create" do
	    event = user.group_events.build(:duration => 3)
	    expect(event).to receive(:is_publishable)
	    event.save
	end
	
	it "runs is_publishable after validations on update" do
	    event = user.group_events.build(:duration => 3)
	    event.save
	    expect(event).to receive(:is_publishable)
	    event.update(:duration => 4)
	end

	it "sets set_end_time after validations on create" do
	    event = user.group_events.build(:duration => 3)
	    expect(event).to receive(:set_end_time)
	    event.save
	end

	it "sets set_end_time after validations on update" do
	    event = user.group_events.build(:duration => 3)
	    event.save
	    expect(event).to receive(:set_end_time)
	    event.update(:duration => 4)
	end

	it "scope :active, include users that are active" do
	    event = user.group_events.build(:duration => 3, :removed => false, :draft => false)
	    event.save
	    expect(GroupEvent.active).to include(event)
	end

	it "sets end_time attribute after create" do
	    event = user.group_events.build(:duration => 1, :start_time => DateTime.now)
	    event.save
	    expect(event.end_time.to_s).to eq((event.start_time + event.duration.days).to_s)
	end

	it "updates end_time attribute on update" do
	    event = user.group_events.build(:duration => 1, :start_time => DateTime.now)
	    event.save
	    event.update(:duration => 4)
	    # as I updated duration field itself
	    expect(event.end_time.to_s).to eq((event.start_time + event.duration.days).to_s)
	end

	xit "convert markdown into HTML after find" do
	    event = user.group_events.build(:duration => 1, :description => "test description")
	    event.save
	    binding.pry
		expect(Redcarpet::Markdown).to receive(:new).with(Redcarpet::Render::HTML) 
		event = GroupEvent.last
	end
end