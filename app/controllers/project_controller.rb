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
    (!!params[:new_room] && params[:new_room] != "") ? room_name = params[:new_room] : room_name = params[:room] 
    room = current_user.rooms.find_or_create_by(name: room_name.downcase, user: current_user)
    project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status], cost: params[:cost], duration: params[:duration])
    redirect "/users/#{project.user.slug}/projects/#{project.slug}"
  end

  get '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name) #refactor to one find statement?

    erb :'projects/show'
  end

  get '/users/:user_slug/projects/:project_slug/edit' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    if current_user == @project.user
      erb :'projects/edit'
    else
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    end

  end

  patch '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    (!!params[:new_room] && params[:new_room] != "") ? room_name = params[:new_room] : room_name = params[:room] 
    room = @project.user.rooms.find_or_create_by(name: room_name.downcase, user: current_user)
    @project.room.destroy if @project.room.projects.size == 1 && @project.room.name != room_name
    @project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status], cost: params[:cost], duration: params[:duration])
    @project.save

    redirect "/users/#{@project.user.slug}/projects/#{@project.slug}" 
  end
  
  delete '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    
    if current_user == @project.user
      @project.room.destroy if @project.room.projects.size == 1
      @project.destroy
      redirect "/users/#{current_user.slug}" 
    else
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    end
  end

end