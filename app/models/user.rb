require_relative './concerns/project_stats.rb'

class User < ActiveRecord::Base
  has_secure_password
  has_many :rooms
  has_many :projects, through: :rooms
  belongs_to :shopping_list
  include ProjectStats
  
  
  def slug
    self.username.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(username: slug.split("-").join(" "))
  end
end