class ProjectController < ApplicationController
  get '/projects' do
    @projects = Project.all.where(status: "Complete")
    erb :'projects/index'
  end

  get '/users/:user_slug/projects/new' do
    erb :'projects/new'
  end

  post '/users/:user_slug/projects' do
    @room = current_user.rooms.find_or_create_by(name: room_name.downcase, user: current_user) if room_name
    @project = Project.new(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: @room, status: params[:status], cost: params[:cost], duration: params[:duration])
    
    if @room.save
      @project.save ? (redirect "/users/#{@project.user.slug}/projects/#{@project.slug}") : (erb :'projects/new')
    else
      erb :'projects/new'
    end

  end

  get '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug])
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
    @room = current_user.rooms.find_or_create_by(name: room_name.downcase, user: current_user) if room_name

    if @project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: @room, status: params[:status], cost: params[:cost], duration: params[:duration])
      destroy_empty_rooms
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    else
      erb :'projects/new'
    end
    
  end
  
  delete '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug]).projects.find_by_slug(params[:project_slug])
    
    if current_user == @project.user
      @project.destroy
      destroy_empty_rooms
      redirect "/users/#{current_user.slug}" 
    else
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}"
    end
    
  end

end