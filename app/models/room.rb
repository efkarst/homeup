require_relative './concerns/project_stats.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  include ProjectStats

  validates :name, presence: { message: "Looks like you already have a room with that name. Pick another name." }
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }
  
  
  def slug
    self.name.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.split("-").join(" "))
  end
end