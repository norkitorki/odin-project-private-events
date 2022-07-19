class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events,
    dependent: :destroy
     
  has_many :event_visitors
  has_many :visits, 
    through: :event_visitors, 
    source: :event, 
    dependent: :destroy
end
