class CollectionController < ApplicationController

  get '/collections' do 
    #binding.pry
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'/collections/index'
    else
      redirect '/login'
    end
  end

  get '/collections/new' do
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'/collections/new'
    else
      redirect '/login'
    end
  end

  post '/collections' do
    user = User.find_by_id(session[:user_id])
    if !params.any? {|key, value| value.empty?} 
      @collection = Collection.create(name: params["name"], description: params["description"])
      @collection.user = user
      @collection.save
      redirect "/collection/#{@collection.slug}"
    end
    ##Error message
    redirect '/collection/new', locals: {message: "Please include a name and description"}
  end

  get '/collections/:slug' do
    if session[:user_id]

      @collection = Collection.find_by_slug(params[:slug])
      binding.pry
      erb :'/collections/show'
    else 
      redirect '/login', locals: {message: "Please log in."}
    end
  end

  delete '/collections/:slug/delete' do
    @user = User.find_by_id(session[:user_id])
    @collection = Collection.find_by_slug(params[:slug])
    if @collection.user == @user
      @collection.delete
      redirect '/collections'
    end
    redirect "/collection/#{@collection.slug}", locals: {message: "You do not have permission to delete this collection."}
  end

  get '/collections/:slug/edit' do
    @collection = Collection.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id]  
      if @collection.user == @user
        erb :'/collections/edit'
      else
        redirect "/collection/#{@collection.slug}", locals: {message: "You do not have permission to edit this collection."}
      end
    else
      redirect '/login', locals: {message: "Please log in."}
    end

  end

  patch '/collections/:slug' do
    @collection = Collection.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])

    if @collection.user == @user 
      if !params[:content].empty?
      @collection.content = params[:content]
      @collection.save
      else
        redirect "/collection/#{@collection.slug}/edit", locals: {message: "Please include a name and description"}
      end
    end
    redirect "/collection/#{@collection.slug}", locals: {message: "You do not have permission to edit this collection."}
  end

end