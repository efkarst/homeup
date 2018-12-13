class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  belongs_to :shopping_list

  validates :name, presence: true
  validates :name, uniqueness: true
  validates_associated :room
  validates :cost, numericality: { only_integer: true}#, :if => :cost.blank? != true
  validates :duration, numericality: { only_integer: true}#, :if => :duration.blank? != true
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }
  

  def slug
    self.name.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.split("-").join(" "))
  end

  
end