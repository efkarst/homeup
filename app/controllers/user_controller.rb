class UserController < ApplicationController
  get '/users/:slug' do
    @user = User.find_by_slug(:username, params[:slug])

    if @user && logged_in?
      erb :'users/show'
    else
      redirect to '/'
    end

  end

end