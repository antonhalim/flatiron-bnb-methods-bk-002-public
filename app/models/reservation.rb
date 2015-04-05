class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :booking_your_own_place?, :avail_at_checkin_and_checkout, :valid_date

  def duration
    (self.checkin...self.checkout).to_a.count
  end

  def total_price
    self.listing.price.to_f * duration
  end

  private
  def valid_date
    if !self.checkin.nil? && !self.checkout.nil? && self.checkin.to_date >= self.checkout.to_date
      errors.add(:checkin, "wrong date input")
    end
  end

  def booking_your_own_place?
    if self.listing.host == self.guest
      errors.add(:guest_id, "you are booking your own spot")
    end
  end

  def avail_at_checkin_and_checkout
    available = true
    self.listing.reservations.each do |reservation|
      booked_dates = (reservation.checkin..reservation.checkout)
      if booked_dates === self.checkin
        errors.add(:checkin, "Its already booked")
      end
      if booked_dates === self.checkout
        errors.add(:checkout, "Its already booked")
      end
    end
  end
end
