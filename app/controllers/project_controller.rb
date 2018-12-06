class ProjectController < ApplicationController
  get '/projects' do
    @projects = Project.all 
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'projects/new'
  end

  post '/projects' do
    # Add validations later that i get right data

    #find or create room
    room = Room.create(name: params[:room].split('_').join(' ').capitalize, user: current_user)
    project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    #fix slug method later to handle cases in names
    redirect "/projects/#{project.slug}"
  end

  get '/projects/:slug/edit' do
    @project = Project.find_by_slug(params[:slug])
    erb :'projects/edit'
  end

  
  patch '/projects/:slug' do
    room_name = params[:room].split('_').join(' ').capitalize
    if !!current_user.rooms.find_by(name: room_name) == false
      room = Room.create(name: params[:room].split('_').join(' ').capitalize, user: current_user)
    else
      room = current_user.rooms.find_by(name: room_name)
    end

    project = current_user.projects.find_by_slug(params[:slug])
    project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    project.save

    redirect "/projects/#{project.slug}" 
  end

  
  get '/projects/:slug' do
    @project = Project.find_by_slug(params[:slug])
    erb :'projects/show'
  end

end