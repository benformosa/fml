# encoding: utf-8

class Car < ActiveRecord::Base
  belongs_to :user
  has_many :trips
  has_many :users, through: :trips
  
  validates :name, presence: true, uniqueness: true
  validates :make, presence: true
  validates :model, presence: true
  validates :rego, presence: true
  validates :state, presence: true
  validates :start_odo, presence: true, numericality: true
  validates :initial_location, presence: true
    
  after_create :initial_trip
  after_save :format_rego
	
  # create a trip representing the odometer reading of the car when it was added to the system
  def initial_trip
    Trip.create({:car => self, :odo => self.start_odo, :user => User.where(login: "unregistered").first, :date => Time.now, :location => initial_location})
  end

  # replace spaces in rego with interpuncts, change to uppercase
  def format_rego
    unless self.rego.nil?
      self.update_column(:rego, self.rego.gsub(' ', '·').upcase)
    end
  end
end
