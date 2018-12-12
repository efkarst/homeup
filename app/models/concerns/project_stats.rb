module ProjectStats
  def total_cost_of_incomplete_projects
    cost = 0
    self.projects.each do |project|
      cost += project.cost.to_i
    end
    cost
  end

  def total_duration_of_incomplete_projects
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

  def complete_projects
    completed = []
    self.projects.each do |project|
      completed << project if project.status == "Complete"
    end
    completed
  end

  def incomplete_projects
    incomplete = []
    self.projects.each do |project|
      incomplete << project if project.status != "Complete"
    end
    incomplete
  end

end