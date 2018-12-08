class RoomController < ApplicationController
  get '/rooms/:slug' do
    @room = current_user.rooms.find_by_slug(params[:slug])
    erb :'rooms/show'
  end

  get '/rooms/:slug/edit' do
    @room = current_user.rooms.find_by_slug(params[:slug])
    erb :'rooms/edit'
  end

  
  patch '/rooms/:slug' do
    @room = current_user.rooms.find_by_slug(params[:slug])
    @room.update(name: params[:name].downcase)
    @room.save

    redirect "/rooms/#{@room.slug}" 
  end

  delete '/rooms/:slug' do
    @room = current_user.rooms.find_by_slug(params[:slug])
    @room.projects.destroy_all
    @room.destroy
    redirect "/users/#{current_user.slug}" 
  end

end