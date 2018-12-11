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

  def total_cost
    cost = 0
    self.projects.each do |project|
      cost += project.cost.to_i
    end
    cost
  end

  def total_duration
    duration = 0
    self.projects.each do |project|
      duration += project.duration.to_i
    end
    duration
  end

  def number_of_projects_completed
    completed = 0
    self.projects.each do |project|
      completed += 1 if project.status == "Complete"
    end
    completed
  end

end