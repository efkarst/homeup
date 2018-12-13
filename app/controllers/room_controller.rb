class RoomController < ApplicationController
  get '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])
    erb :'rooms/show'
  end

  get '/users/:user_slug/rooms/:room_slug/edit' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])
    erb :'rooms/edit'
  end

  patch '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])

    current_user.rooms.each do |room| 
      if room.name == params[:name].downcase && @room.name != room.name
        @exists = true
        break
      else
        @exists = false
      end
    end


    if @exists == true
      @error = "Looks like you already have a room named '#{params[:name]}'. Try another name."
      redirect "/users/#{@room.user.slug}/rooms/#{@room.slug}/edit"
    elsif ((params[:name].scan(/[\d\sa-zA-Z]/).size == params[:name].length) == false) && params[:name] != ""
      @error = "Please enter only numbers (0-9) and letters (a-z) in your room name."
      erb :'rooms/edit' #re-render form to show typed-in values. Flash messages don't seem to work with render.
    else
      @room.update(name: params[:name].downcase)
      @room.save
      redirect "/users/#{@room.user.slug}/rooms/#{@room.slug}" 
    end
  end

  delete '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])
    @room.projects.destroy_all
    @room.destroy
    redirect "/users/#{current_user.slug}" 
  end

end