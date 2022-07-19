class Event < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :date, presence: true
  validates :location, presence: true 

  validate :check_date_validity

  belongs_to :host, class_name: 'User', foreign_key: :user_id

  has_many :event_visitors
  has_many :attendees, through: :event_visitors, source: :user, dependent: :destroy

  private

  def check_date_validity
    date && date < Time.zone.now ? errors.add(:date, "can't be in the past") : true
  end
end
