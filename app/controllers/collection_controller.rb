class CollectionController < ApplicationController

  get '/collections' do 

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
      flash[:error] = "Collection was successfully created."
      redirect "/collections/#{@collection.slug}"
    end
    flash[:error] = "Please include a name and description"
    redirect '/collections/new'
  end

  get '/collections/:slug' do

    if session[:user_id]

      @collection = Collection.find_by_slug(params[:slug])
      erb :'/collections/show'
    else 
      flash[:error] = "Please log in."
      redirect '/login'
    end
  end

  delete '/collections/:slug/delete' do

    @user = User.find_by_id(session[:user_id])
    @collection = Collection.find_by_slug(params[:slug])
    if @collection.user == @user
      @collection.delete
      redirect '/collections'
    end
    flash[:error] = "You do not have permission to delete this collection."
    redirect "/collections/#{@collection.slug}" 
  end

  get '/collections/:slug/edit' do

    @collection = Collection.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id]  
      if @collection.user == @user
        erb :'/collections/edit'
      else
        flash[:error] = "You do not have permission to edit this collection."
        redirect "/collections/#{@collection.slug}"
      end
    else
      flash[:error] = "Please log in."
      redirect '/login'
    end
  end

  patch '/collections/:slug' do

    @collection = Collection.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])

    if @collection.user == @user 
      if !params[:name].empty? && !params[:description].empty? 
      @collection.name = params[:name]
      @collection.description = params[:description]
      @collection.save
      session[:message] = "Collection was successfully updated."
      redirect "/collections/#{@collection.slug}"#, locals: {message: "Collection successfully updated."}

      else
        flash[:error] = "Please include a name and description"
        redirect "/collections/#{@collection.slug}/edit"
      end
    end
    flash[:error] = "You do not have permission to edit this collection."
    redirect "/collections/#{@collection.slug}"
  end



end

