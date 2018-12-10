class SessionController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    user = User.new(name: params[:name], username: params[:username], password: params[:password])

    User.all.each do |user|
      if user.username == params[:username]
        @exists = true
        break
      else
        @exists = false
      end
    end

    if @exists == true
      flash[:signup] = "Sorry, the username '#{params[:username]}' is taken! Try another username."
      redirect '/signup'
    elsif user.name == "" || user.username == "" || user.password == nil
      flash[:signup] = "Make sure you add a name, username and password."
      redirect '/signup'
    elsif user.save
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      flash[:signup] = "Something went wrong. Please try again."
      redirect '/signup'
    end

  end

  get '/login' do
    if logged_in?
      redirect "/users/#{current_user.slug}"
    else
      erb :'users/login'
    end
  end

  post '/login' do 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      flash[:login] = "Incorrect username or password."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end