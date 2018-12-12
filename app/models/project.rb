require_relative './concerns/slug.rb'


class Project < ActiveRecord::Base
  belongs_to :room
  has_one :user, through: :room
  belongs_to :shopping_list
  extend Slug::ClassMethods
  include Slug::InstanceMethods
end