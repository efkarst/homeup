class User < ActiveRecord::Base
  has_secure_password
  has_many :rooms
  has_many :projects, through: :rooms
  belongs_to :shopping_list

  def slug
    self.username.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    # username = slug.split("-").collect{ |word| word}
    self.find_by({username: slug.split("-").join(" ")})
  end

end