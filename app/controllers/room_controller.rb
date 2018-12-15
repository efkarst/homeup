class RoomController < ApplicationController
  get '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])
    erb :'rooms/show'
  end

  get '/users/:user_slug/rooms/:room_slug/edit' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])

    if current_user == @room.user
      erb :'rooms/edit'
    else
      redirect "/users/#{@room.user.slug}/projects/#{@room.slug}"
    end
    
  end

  patch '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])

    if @room.update(name: params[:name].downcase)
      redirect "/users/#{@room.user.slug}/rooms/#{@room.slug}" 
    else
      erb :'rooms/edit'
    end

  end

  delete '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])

    if current_user == @room.user
      @room.projects.destroy_all
      @room.destroy
      redirect "/users/#{current_user.slug}" 
    else
      redirect "/users/#{@room.user.slug}/projects/#{@room.slug}"
    end

  end

end