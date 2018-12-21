class RoomController < ApplicationController
  get '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(:username, params[:user_slug]).rooms.find_by_slug(:name, params[:room_slug])
    erb :'rooms/show'
  end

  get '/users/:user_slug/rooms/:room_slug/edit' do
    @room = User.find_by_slug(:username, params[:user_slug]).rooms.find_by_slug(:name, params[:room_slug])

    if current_user == @room.user
      erb :'rooms/edit'
    else
      redirect "/users/#{@room.user.slug(:username)}/rooms/#{@room.slug(:name)}"
    end
    
  end

  patch '/users/:user_slug/rooms/:room_slug' do
    room = User.find_by_slug(:username, params[:user_slug]).rooms.find_by_slug(:name, params[:room_slug])

    if room.update(name: params[:name].downcase)
      redirect "/users/#{room.user.slug(:username)}/rooms/#{room.slug(:name)}" 
    else
      @errors = room.errors
      @room = Room.find(room.id)
      erb :'rooms/edit'
    end

  end

  delete '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(:username, params[:user_slug]).rooms.find_by_slug(:name, params[:room_slug])

    if current_user == @room.user
      @room.projects.destroy_all
      @room.destroy
      redirect "/users/#{current_user.slug(:username)}" 
    else
      redirect "/users/#{@room.user.slug(:username)}/projects/#{@room.slug(:name)}"
    end

  end

end