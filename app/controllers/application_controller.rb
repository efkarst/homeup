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
      redirect "/users/#{current_user.slug}"
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

    def project_names
      names ||= Project.all.collect do |project|
        project.name
      end
    end
  end

end
