class User < ActiveRecord::Base
  include Tokenable

  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, :full_name

  has_secure_password validations: false

  has_many :queue_items, -> { order(:position) }
  has_many :reviews, -> { order("created_at DESC") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  def queued_video?(video)
    self.queue_items.map(&:video).include?(video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

  def queue_item_in_queue?(queue_item)
    queue_items.include?(queue_item)
  end

  def already_follows?(user)
    following_relationships.map(&:leader).include?(user)
  end

  def can_follow?(user)
    !(self.already_follows?(user) || user == self)
  end

  def follow(user)
    following_relationships.create(leader: user) if can_follow?(user)
  end

  def create_reset_token
    reset_token = SecureRandom.urlsafe_base64
    update_attribute(:reset_token, reset_token)
  end

  def clear_reset_token
    update_attribute(:reset_token, nil)
  end

  def deactivate!
    update_attribute(:active, false)
  end
end
