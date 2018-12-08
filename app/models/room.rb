class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  def slug
    self.name.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.find_by({name: slug.split("-").join(" ")})
  end
end