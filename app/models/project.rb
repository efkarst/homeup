class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  belongs_to :shopping_list

  validates :name, presence: true# { message: "Looks like you already have a project with that name. Pick another name." }
  validates :room, presence: true
  validates :name, uniqueness: true
  validates_associated :room
  validates :cost, numericality: {only_integer: true, allow_nil: true} #, :if => :cost.blank? != true
  validates :duration, numericality: { only_integer: true}#, :if => :duration.blank? != true
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }

  # validate :name_is_bananas

  # def name_is_bananas
  #   if self.name != "bananas" #name isn't bananas
  #     self.errors[:name] << "must be bananas"
  #     #add an error message to name
  #   end
  # end
  # if not validating an attribute, use :base instead of name


  #if there are a bunch of customer validations, build a class

  def slug
    self.name.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.split("-").join(" "))
  end

  
end