require_relative './concerns/slug.rb'

class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  belongs_to :shopping_list
  include Slug::InstanceMethods
  extend Slug::ClassMethods

  validates :name, presence: true
  validate :name_is_unique_to_user
  validates :room, presence: true
  validates_associated :room
  validates :cost, numericality: {only_integer: true, allow_nil: true}
  validates :duration, numericality: { only_integer: true, allow_nil: true}
  validates :name, format: { with: /\A[a-zA-Z\s\d]+\z/,
    message: "only allows letters, numbers, and spaces" }

  def name_is_unique_to_user
    if user_project_names.include?(self.name.downcase) && User.find_by_slug(:username, self.user.slug(:username)).projects.find_by_slug(:name, self.slug(:name)).id != self.id
      self.errors[:base] << "You already have a project named '#{self.name}'"
    end
  end

  def user_project_names
    self.user.projects.all.collect do |project|
      project.name
    end
  end

end