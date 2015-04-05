class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.select do |listing|
      listing.reservations.each do |reservation|
        if !((start_date..end_date) === reservation.checkin) && !((start_date..end_date) === reservation.checkout) && reservation.status == "accepted"
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    ratio = 0
    result = ""
    Neighborhood.all.each do |neighborhood|
        neighborhood_ratio = neighborhood.reservations.count / neighborhood.listings.count.to_f
      if neighborhood_ratio > ratio
        ratio = neighborhood_ratio
        result = neighborhood
      end
    end
      result
  end

  def self.most_res
    number = 0
    neighborhood = ""
    Neighborhood.all.each do |n|
      if n.reservations.count > number
        number = n.reservations.count
        neighborhood = n
      end
    end
    neighborhood
  end

end
