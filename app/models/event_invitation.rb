class EventInvitation < ApplicationRecord
  scope :rejected, -> { where(status: -1) }
  scope :pending, -> { where(status: 0) }
  scope :accepted, -> { where(status: 1) }

  belongs_to :event
  belongs_to :user

  validates :status, presence: true, comparison: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
end
