class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { maximum: 40 }

  has_many :events,
    dependent: :destroy
     
  has_many :event_visitors
  has_many :visits, 
    through: :event_visitors, 
    source: :event, 
    dependent: :destroy
end
