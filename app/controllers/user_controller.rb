class UsersController < ApplicationController

  get '/users/:slug' do 
    @tweets = User.find_by_slug(params[:slug]).tweets
    @user = User.find_by_slug(params[:slug])

    erb :'/tweets/show'
  end

  get '/tweets/new' do

  end

  get '/tweets/:id' do

  end

end