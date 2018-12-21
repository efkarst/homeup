require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class User < ActiveRecord::Base
  # Active record secure password macro
  has_secure_password
  
  # Active Record Associations
  has_many :rooms
  has_many :projects

  # Include and extend methods from ProjectStats and Slug modules
  include ProjectStats
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  # Active Record Validations
  validates :name, :username, :password, presence: true
  validates :username, format: { with: /\A[a-zA-Z\d]+\z/,
    message: "only allows letters and numbers" }
  
end