require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base


  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions unless test?
    set :session_secret, "secret"
    register Sinatra::Flash
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
    flash[:error] = "Username or password do not match. Please try again."
    redirect '/login'
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
    flash[:error] = "Please fill in all fields"
    redirect '/signup'
    
  end


  

  get '/logout' do
    session.clear
    redirect '/login'
  end



end