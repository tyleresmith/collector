class UserController < ApplicationController

  get '/users' do

    erb :'/users/list'
  end

  get '/users/collections/:slug' do
    @collection = Collection.find_by_slug(params[:slug])

    erb :'/users/show'
  end

  get '/users/collections' do
    erb :'/users/collections'
  end

  get '/users/browse' do
    erb :'/users/browse'
  end

  get '/users/:slug' do 
    
    @user = User.find_by_slug(params[:slug])
    erb :'/users/index'
  end


  get '/users/items/:slug' do
    @item = Item.find_by_slug(params[:slug])
    
    erb :'/users/single'
  end



end