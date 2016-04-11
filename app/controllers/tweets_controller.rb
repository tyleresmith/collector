class TweetsController < ApplicationController

  get '/tweets' do 
    #binding.pry
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'/tweets/index'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      erb :'/tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    user = User.find_by_id(session[:user_id])
    if !params.any? {|key, value| value.empty?} 
      @tweet = Tweet.create(content: params["content"])
      @tweet.user = user
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    end
    redirect '/tweets/new'
  end

  get '/tweets/:id' do
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/single'
    else 
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    @user = User.find_by_id(session[:user_id])
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user == @user
      @tweet.delete
      redirect '/tweets'
    end
    redirect "/tweets/#{params[:id]}"
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])
    if session[:user_id]  
      if @tweet.user == @user
        erb :'/tweets/edit'
      else
        redirect "/tweets/#{@tweet.id}"
      end
    else
      redirect '/login'
    end

  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])

    if @tweet.user == @user 
      if !params[:content].empty?
      @tweet.content = params[:content]
      @tweet.save
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end
    end
    redirect "/tweets/#{@tweet.id}"
  end

end