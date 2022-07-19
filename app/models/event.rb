class Event < ApplicationRecord
  belongs_to :host, class_name: 'User', foreign_key: :user_id

  has_many :event_visitors
  has_many :attendees, through: :event_visitors, source: :user, dependent: :destroy
end
