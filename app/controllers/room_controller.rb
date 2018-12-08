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
    @room.update(name: params[:name].downcase)
    @room.save

    redirect "/users/#{@room.user.slug}/rooms/#{@room.slug}" 
  end

  delete '/users/:user_slug/rooms/:room_slug' do
    @room = User.find_by_slug(params[:user_slug]).rooms.find_by_slug(params[:room_slug])
    @room.projects.destroy_all
    @room.destroy
    redirect "/users/#{current_user.slug}" 
  end

end