require './config/environment'
require 'sinatra/flash'
require 'sinatra/content_for'

class ApplicationController < Sinatra::Base 
  helpers Sinatra::ContentFor # Enables use of multiple yield statements in layout
  register Sinatra::Flash     # Enable flash messages for some errors

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  # Render index page, or user home page if they are already logged in
  get "/" do
    if logged_in?
      redirect "/users/#{current_user.slug(:username)}"
    else
      erb :index
    end
  end

  # Helper methods to provide logic needed in views
  helpers do
    # Return true if user is logged in
    def logged_in?
      !!session[:user_id]
    end

    # redirects to useful place if not logged in
    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/'
      end
    end

    # Return instance of user who is currently signed in
    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    # Return room name user submitted in form via either new_room field or rooms radio buttons
    def room_name
      if params[:new_room].blank? == false
        params[:new_room]
      elsif params[:room]
        params[:room]
      else
        ""
      end
    end

    # Iterate through empy rooms and destroys those without projects
    def destroy_empty_rooms
      current_user.rooms.each do |room|
        room.destroy if room.projects.count == 0
      end
    end

  end

end
