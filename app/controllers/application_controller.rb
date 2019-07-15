class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/' do
    erb :home
  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do
    erb :'/registrations/signup', layout: :'/layouts/my_layout'
  end

  # Handles the POST request when user submits the Sign Up form. Get user info from the params hash, creates a new user, signs them in, redirects them. 
  post '/registrations' do
  #  byebug
   user = User.create(name: params["name"], email: params["email"])
   user.password =  params["password"]
   user.save
   session[:user_id] = user.id 
   redirect 'users/home', layout: :'/layouts/user_layout'
  end
  
  # Renders the view page in app/views/sessions/login.erb
  get '/sessions/login' do
   erb :'/sessions/login', layout: :'/layouts/my_layout'
  end

  # Handles the POST request when user submites the Log In form. Similar to above, but without the new user creation.
  post '/sessions' do
    user = User.find_by(email: params["email"])
    if user.password == params["password"]
    session[:user_id] = user.id
    redirect 'users/home'
    else
    redirect 'sessions/login'
    end
  end

  # Logs the user out by clearing the sessions hash. 
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  # Renders the user's individual home/account page. 
  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home', layout: :'/layouts/user_layout'
  end

  #displaying user's toys
  # get '/show/all_items' do
  #   @items = Item.all
  #   erb :'/show/all_items', layout: :'/layouts/my_layout'
  # end

  # post 'items' do
  #   # byebug
  #   @user = User.find(session[:user_id])
  #   sub_category = SubCategory.find_by(:sub_category_name params["sub_category"]) 
  #   @new_item = Item.create(item_name: params["name"], image_url: params["image_url"], description: params["description"], price: params["price"], user_id: @user.id, sub_category: sub_category)
  #   redirect 'users/home', layout: :'/layouts/user_layout'
  # end

#   get '/forms/form' do
#     @user = User.find(session[:user_id])
#     erb :'/forms/form', layout: :'/layouts/user_layout'
#   end
end



# get /cars/id
# @user = User.find(session[:user_id])
# Item = Item.find(params[:id].to_i)

# post '/items' do
#   @user = User.find(session[:user_id])