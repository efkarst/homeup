require_relative './concerns/project_stats.rb'
require_relative './concerns/slug.rb'

class Room < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  include ProjectStats
  include Slug::InstanceMethods
  extend Slug::ClassMethods
  include ActiveModel::Validations
  validates_with MyValidator

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "of room only allows letters, numbers, and spaces" }
  
end