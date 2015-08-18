class Trip < ActiveRecord::Base
  belongs_to :last_trip, :class_name => "Trip",
    :foreign_key => "last_trip"

  validate :greater_than_last_trip
    
  belongs_to :car
  validates :car_id, presence: true

  belongs_to :user
  validates :user_id, presence: true

  validates :odo, presence: true, numericality: true
  validates :location, presence: true
  validates :date, presence: true

  before_save :set_distance

  # Is this the car's initial trip?
  def initial_trip?
    Trip.where(car_id: car).empty? or odo.nil? or last_trip.nil?
  end

  # Calculate the trip's distance. If this is the first trip for this car, return 0
  def get_distance
    if initial_trip?
      return 0
    else
      odo - last_trip.odo
    end
  end

  def set_distance
   self.distance = get_distance 
  end

  # Validate that the odometer reading has gone up and that the date is not earlier, except for the initial trip
  def greater_than_last_trip
    unless initial_trip?
      if last_trip.odo >= odo
        errors.add(:base, "Odometer reading must be greater than the reading from the last trip")
      end

      if last_trip.date > date
        errors.add(:base, "Date cannot be earlier than date of previous trip")
      end
    end
  end
end
