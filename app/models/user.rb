class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, :full_name

  has_secure_password validations: false

  has_many :queue_items, -> { order(:position) }
  has_many :reviews, -> { order("created_at DESC") }

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
end