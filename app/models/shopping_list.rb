class ShoppingList < ActiveRecord::Base
  belongs_to :user
  has_many :projects
end