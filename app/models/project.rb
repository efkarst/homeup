require_relative './concerns/slug.rb'

class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  include ActiveModel::Validations
  validates_with MyValidator
  validates :name, presence: true
  validates :room, presence: true
  validates_associated :room
  validates :cost, numericality: {only_integer: true, allow_nil: true}
  validates :duration, numericality: { only_integer: true, allow_nil: true}
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }

end