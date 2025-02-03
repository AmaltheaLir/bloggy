require 'sinatra'
require 'sequel'
require 'sqlite3'


#define your autehentication method
def protected!
  return if authorized?
  headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
  halt 401, "Ye best go back now, y'hear....looks like ya doona' belong here, bub\n"
end

def authorized?
  @auth ||= Rack::Auth::Basic::Request.new(request.env)
  @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'secret']
end


DB = Sequel.sqlite('storage/app.db')

get '/' do
  @posts = DB[:posts]
  @time_of_day = Time.now.to_s
  erb :posts
end

#retrieve new post, save to database, .insert redirects to the created post! 
post '/posts' do
  id = DB[:posts].insert(
    title: params[:title],
    author: params[:author],
    date_added: params[:date_added],
    content: params[:content]
  )

  redirect "/posts/#{id}"
end

#1 go to the Edit.erb view page 
get '/posts/edit' do
  @posts = DB[:posts]
 
  erb :posts_edit
end

#NEW Admin View
get '/admin' do
  #for auth
  protected!
  # @posts = DB[:posts]
  "Secret tunnel"
  erb :admin
end

#to show the selected post by given post id
get '/posts/:id' do
  @post = DB[:posts].where(id: params["id"]).first

  erb :post
end

#2 link from index table or indiv post, to iniv post_edit_form view/page. :id _ONEEE
get '/posts/:id/edit' do
  @post = DB[:posts].where(id: params["id"]).first

  erb :post_edit_form
  #erb :admin
end


#to UPDATE
put '/posts/:id' do
  p params
  DB[:posts].where(id: params["id"]).update(params.slice("title", "author", "date_added","content"))

  redirect "/posts/edit"
end

post "/posts/:id/remove" do
  DB[:posts].where(id: params["id"]).delete

  redirect "/posts/edit"
end

