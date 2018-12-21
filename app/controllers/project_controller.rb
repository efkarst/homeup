class ProjectController < ApplicationController
  before do
    redirect_if_not_logged_in
  end

  # Render all projects
  get '/projects' do
    @projects = Project.all
    erb :'projects/index'
  end

  # Render view with new project form for the current user
  get '/users/:user_slug/projects/new' do
    erb :'projects/new'
  end 

  # Create project with data posted from 'new project' form and redirect to user home page if there aren't validation errors
  post '/users/:user_slug/projects' do
    @room = current_user.rooms.find_or_initialize_by(name: room_name.downcase, user: current_user)
    @project = Project.new(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: @room, status: params[:status], cost: params[:cost], duration: params[:duration], user: current_user)

    if @room.save && @project.save 
      redirect "/users/#{@project.user.slug(:username)}/projects/#{@project.slug(:name)}"
    else
      erb :'projects/new'
    end

  end

  # Render view to show details on a specific project
  get '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(:username, params[:user_slug]).projects.find_by_slug(:name, params[:project_slug])
    erb :'projects/show'
  end

  # Render view with edit form for a specific project if it belongs to the current user
  get '/users/:user_slug/projects/:project_slug/edit' do
    @project = User.find_by_slug(:username, params[:user_slug]).projects.find_by_slug(:name, params[:project_slug])
    
    if current_user == @project.user
      erb :'projects/edit'
    else
      redirect "/users/#{@project.user.slug(:username)}/projects/#{@project.slug(:name)}"
    end

  end

  # Update project with data posted from 'edit project' form and redirect user to project show page if there aren't validation errors
  patch '/users/:user_slug/projects/:project_slug' do
    project = User.find_by_slug(:username, params[:user_slug]).projects.find_by_slug(:name, params[:project_slug])
    @room = current_user.rooms.find_or_initialize_by(name: room_name.downcase, user: current_user)

    if @room.save && project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: @room, status: params[:status], cost: params[:cost], duration: params[:duration], user: current_user)
      destroy_empty_rooms
      redirect "/users/#{project.user.slug(:username)}/projects/#{project.slug(:name)}"
    else
      @errors = project.errors
      @project = Project.find(project.id)
      erb :'projects/edit'
    end
    
  end
  
  # Delete project if it belongs to the current user
  delete '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(:username, params[:user_slug]).projects.find_by_slug(:name, params[:project_slug])
    
    if current_user == @project.user
      @project.destroy
      destroy_empty_rooms
      redirect "/users/#{current_user.slug(:username)}" 
    else
      redirect "/users/#{@project.user.slug(:username)}/projects/#{@project.slug(:name)}"
    end
    
  end

end