require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  include ProjectStats
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  validates :name, presence: { message: "of room can't be blank" }
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "of room only allows letters, numbers, and spaces" }
  validate :name_is_unique_to_user

  def name_is_unique_to_user
    if user_room_names.include?(self.name.downcase) && User.find_by_slug(:username, self.user.slug(:username)).rooms.find_by_slug(:name, self.slug(:name)).id != self.id
      self.errors[:base] << "You already have a room named '#{self.name}'"
    end
  end

  def user_room_names
    self.user.rooms.all.collect do |room|
      room.name
    end
  end
  
end