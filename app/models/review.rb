class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation_id, presence: true
  validate :valid_reservation, :reservation_accepted

  private
  def valid_reservation
    if self.reservation && reservation.checkout > Date.today
      errors.add(:reservation_id, "You cant review reservation that you havent checkout")
    end
  end

  def reservation_accepted
    if self.reservation && self.reservation.status != "accepted"
      errors.add(:reservation_id, "Your reservation is not accepted")
    end
  end
end
