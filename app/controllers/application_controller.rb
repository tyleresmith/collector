require './config/environment'


class ApplicationController < Sinatra::Base

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
      redirect '/tweets'
    end
  end

  get '/signup' do
    if !session[:user_id]
      erb :signup
    else
      redirect '/tweets' 
    end

  end

  post '/signup' do


    if !params.any? {|key, value| value.empty?} 
      @user = User.create(params)
      session[:user_id] = @user.id
     
      redirect '/tweets'
    end

    redirect '/signup'

  end


  post '/login' do
    

    if current_user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      redirect to '/tweets'
    end
    redirect '/login'
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end


  helpers do

    def current_user(session_info)
      @user = User.find_by_id(session_info["user_id"])
    end

    def is_logged_in?(session_info)
      !!session_info["user_id"]
    end

  end
end