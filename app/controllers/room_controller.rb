class RoomController < ApplicationController
  get '/rooms/:slug' do
    @room = current_user.rooms.find_by_slug(params[:slug])
    erb :'rooms/show'
  end
end