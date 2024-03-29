class Event < ApplicationRecord
  scope :upcoming, -> { where("start_date > ?", Time.now.utc) }
  scope :previous, -> { where("start_date < ?", Time.now.utc) }

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, :location, :start_date, :end_date, presence: true
  validates :private, comparison: { greater_than: -1, less_than: 2 }

  validate :validate_event_dates

  belongs_to :host,
    class_name: 'User',
    foreign_key: :user_id

  has_many :event_visitors
  has_many :attendees,
    through: :event_visitors,
    source: :user,
    dependent: :destroy

  has_many :event_invitations
  has_many :invited_users,
    through: :event_invitations,
    source: :user,
    dependent: :destroy

  def in_the_past?
    start_date < Time.now.utc ? true : false
  end

  def private?
    private == 1
  end

  private

  def validate_event_dates
    if start_date && start_date < Time.zone.now
      errors.add(:start_date, "can't be in the past")
    end

    if start_date && end_date && end_date <= start_date
      errors.add(:end_date, "can't be before the starting date")
    end
  end
end
