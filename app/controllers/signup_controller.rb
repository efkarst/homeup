class SignupController < ApplicationController
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

end