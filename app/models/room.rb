require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class Room < ActiveRecord::Base
  # Active Record Associations
  belongs_to :user
  has_many :projects

  # Include and extend methods from ProjectStats and Slug modules
  include ProjectStats
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  # Active Record Validations
  validates_with MyValidator
  validates :name, presence: {message: "of room can't be blank"}
   validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "of room only allows letters, numbers, and spaces" }
  
end