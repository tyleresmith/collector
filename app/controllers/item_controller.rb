class ItemsController < ApplicationController

  


  get '/items/new' do
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'/items/new'
    else
      redirect '/login'
    end
  end

  post '/items' do
    

    user = User.find_by_id(session[:user_id])
    if !params[:name].empty? && !!params[:collection]
      @item = Item.create(name: params["name"], collection_id: params["collection"], description: params["description"])
      
      if !!params[:picture]
        puts Dir.pwd
        File.open(Dir.pwd + '/app/views/items/uploads/' + params['picture'][:filename], "wb") do |f|
          f.write(params['picture'][:tempfile].read)
        end 
        @item.picture = params["picture"][:filename]
      end
      @item.save
      flash[:error] = "Item was successfully created"
      redirect "/collections/#{@item.collection.slug}"
    end
    flash[:error] = "Please include a name and collection"
    redirect '/items/new'
  end

  get '/items/:slug' do

    if session[:user_id]

      @item = Item.find_by_slug(params[:slug])
      erb :'/items/show'
    else 
      flash[:error] = "Please log in"
      redirect '/login'
    end
  end

  delete '/items/:slug/delete' do

    @user = User.find_by_id(session[:user_id])
    @item = Item.find_by_slug(params[:slug])
    if @item.collection.user == @user
      @item.delete
      redirect "/collections/#{@item.collection.slug}"
    end
    flash[:error] = "You do not have permission to delete this item"
    redirect "/items/#{@item.slug}" 
  end

  get '/items/:slug/edit' do

    @item = Item.find_by_slug(params[:slug])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id]  
      if @item.collection.user == @user
        erb :'/items/edit'
      else
        flash[:error] = "You do not have permission to edit this item."
        redirect "/collections/#{@collection.slug}"
      end
    else
      flash[:error] = "Please log in."
      redirect '/login'
    end
  end

  patch '/items/:slug' do
    @item = Item.find_by_slug(params[:slug])
    user = User.find_by_id(session[:user_id])
    if !params[:name].empty? && !!params[:collection]
      @item.update(name: params["name"], collection_id: params["collection"], description: params["description"])
      
      if !params[:picture].empty?
        puts Dir.pwd
        File.open(Dir.pwd + '/app/views/items/uploads/' + params['picture'][:filename], "wb") do |f|
          f.write(params['picture'][:tempfile].read)
        end 
        @item.picture = params["picture"][:filename]
      end
      @item.save
      flash[:error] = "Item was successfully edit"
      redirect "/collections/#{@item.collection.slug}"
    end
    flash[:error] = "Please include a name and collection"
    redirect "/items/#{@item.slug}/edit"
  end

end