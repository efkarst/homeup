class RoomController < ApplicationController
  get '/rooms/:slug' do
    @room = Room.find_by_slug(params[:slug])
    erb :'rooms/show'
  end
end