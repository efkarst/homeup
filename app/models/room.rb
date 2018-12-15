require_relative './concerns/project_stats.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  include ProjectStats

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }
  validate :name_is_unique_to_user

  def name_is_unique_to_user
    if user_room_names.include?(self.name.downcase) && Room.find_by_slug(self.slug).id != self.id
      self.errors[:base] << "You already have a room named '#{self.name}'"
    end
  end

  def user_room_names
    self.user.rooms.all.collect do |room|
      room.name
    end
  end
  
  def slug
    self.name.split(" ").join("-").downcase
  end

  def self.find_by_slug(slug)
    self.find_by(name: slug.split("-").join(" "))
  end
end