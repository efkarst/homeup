require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects
  include ProjectStats
  extend Slug::ClassMethods
  include Slug::InstanceMethods
end