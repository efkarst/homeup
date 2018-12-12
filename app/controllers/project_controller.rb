class ProjectController < ApplicationController
  get '/projects' do
    @projects = Project.all.where(status: "Complete")
    erb :'projects/index'
  end

  get '/projects/new' do
    erb :'projects/new'
  end

  post '/projects' do
    if project_names.include?(params[:name]) == true
      session[:new_project] = "Looks like you already have a project with that name. Pick another name."
      erb :'projects/new' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif params[:new_room] == "" && params[:room] == nil
      session[:new_project] = "Please add or choose a room."
      erb :'projects/new' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:cost].scan(/[0-9]/).size == params[:cost].length) == false) && params[:cost] != ""
      session[:new_project] = "Please enter only number 0-9 for cost."
      erb :'projects/new' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:duration].scan(/[0-9]/).size == params[:duration].length) == false) && params[:cost] != ""
      session[:new_project] = "Please enter only number 0-9 for duration."
      erb :'projects/new' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif (params[:name].scan(/[\d\sa-zA-Z]/).size == params[:name].length) == false
      session[:new_project] = "Please enter only numbers (0-9) and letters (a-z) in your project name."
      erb :'projects/new' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:new_room].scan(/[\d\sa-zA-Z]/).size == params[:new_room].length) == false) && params[:new_room] !=""
      session[:new_project] = "Please enter only numbers (0-9) and letters (a-z) in your room name."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    else
      (!!params[:new_room] && params[:new_room] != "") ? room_name = params[:new_room] : room_name = params[:room] 
      room = current_user.rooms.find_or_create_by(name: room_name.downcase, user: current_user)
      project = Project.create(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status], cost: params[:cost], duration: params[:duration])
      redirect "/users/#{project.user.slug}/projects/#{project.slug}"
    end
  end

  get '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    erb :'projects/show'
  end

  get '/users/:user_slug/projects/:project_slug/edit' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    (current_user == @project.user) ? (erb :'projects/edit') : (redirect "/users/#{@project.user.slug}/projects/#{@project.slug}")
  end

  patch '/users/:user_slug/projects/:project_slug' do
    @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
    if project_names.include?(params[:name]) == true && @project.name != params[:name]
      session[:edit_project] = "Looks like you already have a project with that name. Pick another name."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif params[:new_room] == "" && params[:room] == nil
      session[:edit_project] = "Please add or choose a room."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:cost].scan(/[0-9]/).size == params[:cost].length) == false) && params[:cost] != ""
      session[:edit_project] = "Please enter only number 0-9 for cost."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:duration].scan(/[0-9]/).size == params[:duration].length) == false) && params[:cost] != ""
      session[:edit_project] = "Please enter only number 0-9 for duration."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif (params[:name].scan(/[\d\sa-zA-Z]/).size == params[:name].length) == false
      session[:edit_project] = "Please enter only numbers (0-9) and letters (a-z) in your project name."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    elsif ((params[:new_room].scan(/[\d\sa-zA-Z]/).size == params[:new_room].length) == false) && params[:new_room] !=""
      session[:edit_project] = "Please enter only numbers (0-9) and letters (a-z) in your room name."
      erb :'projects/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    else
      @project = User.find_by_slug(params[:user_slug],:username).projects.find_by_slug(params[:project_slug],:name)
      (!!params[:new_room] && params[:new_room] != "") ? room_name = params[:new_room] : room_name = params[:room] 
      room = @project.user.rooms.find_or_create_by(name: room_name.downcase, user: current_user)
      @project.room.destroy if @project.room.projects.size == 1 && @project.room.name != room_name
      @project.update(name: params[:name].downcase, description: params[:description], materials: params[:materials], room: room, status: params[:status], cost: params[:cost], duration: params[:duration])
      @project.save
  
      redirect "/users/#{@project.user.slug}/projects/#{@project.slug}" 
    end
    
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