class ProjectController < ApplicationController
  get '/projects' do
    @projects = Project.all.where(status: "Complete")
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'projects/new'
  end

  post '/projects' do
    # Add validations later that i get right data & names don't include symbols
    # validate project name doesnt already exist to ensure uniqueness
    room = current_user.rooms.find_or_create_by(name: params[:room].downcase, user: current_user)
    project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    redirect "/users/#{project.user.slug}/projects/#{project.slug}"
  end

  get '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug]) #refactor to one find statement?
    erb :'projects/show'
  end

  get '/users/:user_slug/projects/:project_slug/edit' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug])

    if current_user == @project.user
      erb :'projects/edit'
    else
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    end

  end

  patch '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug])
    room = @project.user.rooms.find_or_create_by(name: params[:room].downcase, user: current_user)
    @project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    @project.save

    redirect "/users/#{@project.user.slug}/projects/#{@project.slug}" 
  end
  
  delete '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug])

    if current_user == @project.user
      @project.destroy
      redirect "/users/#{current_user.slug}" 
    else
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    end
  end

end