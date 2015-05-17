class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, :full_name

  has_secure_password validations: false

  has_many :queue_items
end