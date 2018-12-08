class SessionController < ApplicationController
  get '/signup' do
    #if user is already signed in, reroute 
    erb :'users/signup'
  end

  post '/signup' do
    user = User.new(name: params[:name], username: params[:username], password: params[:password])

    if user.name == "" || user.username == "" || user.password == nil
      redirect '/signup'
    elsif user.save
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      redirect '/signup'
      #refactor and include error messaging
    end

  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      redirect '/login' #do error messaging
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end