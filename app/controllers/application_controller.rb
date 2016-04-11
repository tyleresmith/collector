require './config/environment'

require "sinatra/reloader" if development?

class ApplicationController < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end


  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/login' do
    if !session[:user_id]
      erb :index
    else
      redirect '/collections'
    end
  end

  post '/login' do
    @user = User.find_by(:name => params[:name])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      redirect to '/collections'
    end
    redirect '/login',  locals: {message: "Username or password do not match. Please try again."}
  end

  get '/signup' do
    if !session[:user_id]
      erb :signup
    else
      redirect '/collections' 
    end

  end

  post '/signup' do

    if !params.any? {|key, value| value.empty?} && !User.find_by_name(params["name"])
      @user = User.create(params)
      session[:user_id] = @user.id
     
      redirect '/collections'
    end

    redirect '/signup', locals: {message: "Please enter fill in all fields"}
    
  end


  

  get '/logout' do
    session.clear
    redirect '/login'
  end


end