require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class User < ActiveRecord::Base
  has_secure_password
  has_many :rooms
  has_many :projects, through: :rooms
  belongs_to :shopping_list
  include ProjectStats
  extend Slug::ClassMethods
  include Slug::InstanceMethods
end