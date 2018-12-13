require_relative './concerns/project_stats.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  include ProjectStats
  
  
  def slug
    self.name.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.split("-").join(" "))
  end
end