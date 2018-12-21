class SessionController < ApplicationController
  # Render view with signup form, or redirect to user show page if already logged in
  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug(:username)}"
    else
      erb :'users/signup'
    end
  end

  # Create user with data posted from 'signup' form and redirect to user home page if there aren't validation errors
  post '/signup' do
    @user = User.new(name: params[:name], username: params[:username], password: params[:password])

    if @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug(:username)}"
    else
      erb :'users/signup'
    end

  end

  # Render view with login form, or redirect to user show page if already logged in
  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug(:username)}"
    else
      erb :'users/login'
    end
  end

  # Log user in and redirect to user show page if the user exists and authenticates
  post '/login' do 
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug(:username)}"
    else
      flash[:login] = "Incorrect username or password."
      redirect '/login'
    end
    
  end

  # Log current user out
  get '/logout' do
    session.clear
    redirect '/'
  end

end