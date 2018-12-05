class LoginController < ApplicationController
  #need to determine if login / signup belong in user controller or elsewhere
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