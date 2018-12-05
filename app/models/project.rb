class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  belongs_to :shopping_list

  def slug
    self.name.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.find_by({name: slug.split("-").join(" ")})
  end
end