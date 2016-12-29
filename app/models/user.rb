class User < ApplicationRecord
	has_many :group_events
	
	validates :name, presence: true
end
