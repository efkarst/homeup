require './config/environment'
require 'sinatra/flash'
require 'sinatra/content_for'

class ApplicationController < Sinatra::Base
  helpers Sinatra::ContentFor
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security" #need to change this?
  end

  get "/" do
    if logged_in?
      redirect "/users/#{current_user.slug(:username)}"
    else
      erb :index
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      current_user ||= User.find(session[:user_id])
    end

    def room_name
      if params[:new_room].blank? == false
        params[:new_room]
      elsif params[:room]
        params[:room]
      else
        ""
      end
    end

    def destroy_empty_rooms
      current_user.rooms.each do |room|
        room.destroy if room.projects.count == 0
      end
    end

  end

end
