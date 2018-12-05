class UserController < ApplicationController
  get '/projects' do
    @projects = Project.all 
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'projects/new'
  end

  post '/projects' do
    # Add validations later that i get right data
    room = Room.create(name: params[:room].split('_').join(' ').capitalize, user: current_user)
    project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status])
    #fix slug method later to handle cases in names
    redirect "/projects/#{project.slug}"
  end

  get '/projects/:slug/edit' do
    erb :'projects/edit'
  end

  
  get '/projects/:slug' do
    @project = Project.find_by_slug(params[:slug])
    erb :'projects/show'
  end

end