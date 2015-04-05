class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_save :update_user_to_host
  before_destroy :update_user_to_peasant

  def average_rating
    reviews = 0
    self.reviews.each do |review|
      reviews += review.rating
    end
    reviews.to_f / self.reviews.count
  end
  private

  def update_user_to_host
    self.host.update(host: true)
  end
  def update_user_to_peasant
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end
end
