require_relative './concerns/slug.rb'

class Project < ActiveRecord::Base
  # Active Record Associations
  belongs_to :room
  belongs_to :user
  
  # Include and extend methods from ProjectStats and Slug modules
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  # Active Record Validations
  validates_with MyValidator
  validates :name, presence: true
  validates :room, presence: true
  validates_associated :room # run validations for associated room
  validates :cost, numericality: {only_integer: true, allow_nil: true} # allow_nil skips validation if the value being evaluated is nil
  validates :duration, numericality: { only_integer: true, allow_nil: true}
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }

end