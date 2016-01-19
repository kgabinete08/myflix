class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name ["myflix", Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def self.search(query, options = nil)
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ['title^100', 'description^50'],
          operator: "and"
        }
      }
    }

    if query.present? && options
      search_definition[:query][:multi_match][:fields] << "reviews.content"
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options = nil)
    as_json(
      only: ['title', 'description'],
      include: {
        reviews: { only: [:content] }
      }
    )
  end
end
