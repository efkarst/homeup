module ProjectStats

  # Total cost of incomplete projects that belong to self
  def total_cost_of_incomplete_projects
    cost = 0
    self.incomplete_projects.each do |project|
      cost += project.cost.to_i
    end
    cost
  end

  # Total duration of incomplete projects that belong to self
  def total_duration_of_incomplete_projects
    duration = 0
    self.incomplete_projects.each do |project|
      duration += project.duration.to_i
    end
    duration
  end

  # Total number of projects completed that belong to self
  def number_of_projects_completed
    complete_projects.size
  end

  # Array of projects completed that belong to self
  def complete_projects
    completed = []
    self.projects.each do |project|
      completed << project if project.status == "Complete"
    end
    completed
  end

  # Array of incomplete projects that belong to self 
  def incomplete_projects
    incomplete = []
    self.projects.each do |project|
      incomplete << project if project.status != "Complete"
    end
    incomplete
  end

end