class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
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
    result_city = ""
    City.all.each do |city|
        city_ratio = city.reservations.count / city.listings.count.to_f
      if city_ratio > ratio
        ratio = city_ratio
        result_city = city
      end
    end
      result_city
  end

  def self.most_res
    number = 0
    result_city = ""
    City.all.each do |city|
      counted = city.reservations.count
      if counted > number
        number = counted
        result_city = city
      end
    end
    result_city
  end
end
