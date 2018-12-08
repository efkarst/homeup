class ProjectController < ApplicationController
  get '/projects' do
    @projects = Project.all 
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'projects/new'
  end

  post '/projects' do
    # Add validations later that i get right data & names don't include symbols
    # validate project name doesnt already exist
    room = current_user.rooms.find_or_create_by(name: params[:room].downcase, user: current_user)
    project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    redirect "/projects/#{project.slug}"
  end

  get '/projects/:slug/edit' do
    @project = Project.find_by_slug(params[:slug])

    if current_user == @project.user
      erb :'projects/edit'
    else
      redirect "/projects/#{@project.slug}"
    end

  end

  
  patch '/projects/:slug' do
    project = current_user.projects.find_by_slug(params[:slug])
    room = current_user.rooms.find_or_create_by(name: params[:room].downcase, user: current_user)
    project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    project.save

    redirect "/projects/#{project.slug}" 
  end

  
  get '/projects/:slug' do
    @project = Project.find_by_slug(params[:slug])
    erb :'projects/show'
  end
  
  delete '/projects/:slug' do
    @project = current_user.projects.find_by_slug(params[:slug])
    @project.destroy
    redirect "/users/#{current_user.slug}" 
  end

end