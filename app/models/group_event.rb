# == Schema Information
#
# Table name: group_events
#
#  id          :integer          not null, primary key
#  duration    :integer
#  start_time  :datetime
#  end_time    :datetime
#  name        :string
#  description :string
#  location    :string
#  draft       :boolean
#  removed     :boolean
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null

class GroupEvent < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :duration, :numericality => { :only_integer => true }
  after_validation :is_publishable, on: [ :create, :update ]
  after_validation :set_end_time, on: [ :create, :update ] 

  scope :is_draft, -> { where(draft: true) } 
  scope :is_published, -> { where(draft: false) }
  scope :active, -> { where(removed: false).where(draft: false) }
 
  after_find do 
    if self.end_time.present? && DateTime.now > self.end_time
      self.removed = true
      self.save
    end 
  end

  after_find do 
    if self.description.present?
      self.description =  self.class.markdown.render(self.description)
    end
  end

private
  def is_publishable
	if %w( duration start_time end_time name description location ).all? { |attr| self[attr].present? }
      self.draft = false
      true
    else
      false	 
    end
  end

  def set_end_time
  	if self.start_time.present?
	  # duration.days from ActiveSupport::Duration
      self.end_time = self.start_time + self.duration.days	 
    end
  end

  def self.markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
