require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/base'
require './lib'

#curl -F 'access_token=AAAE2kaTFCrYBAD0cZC8OtzOqD2kT8QWIHpoaxaGuRyoUZAbJd8RRL4aTvZCSMh8fnMjnc8AErL4PLEbQJQzYKiBuC9zZCZBUaEXHMR7TSJAZDZD' \
#     -F 'movie=http://movies.alagu.net/Oru_Kal_Oru_Kannadi.html' \
#        'https://graph.facebook.com/me/video.watches'
#

get '/' do
  haml :index, :format => :html5
end

get '/auth' do
  client = get_fb_client
  redirect client.authorization_uri(:scope => [:email, :publish_actions, :'user_actions.video'])
end

get '/callback' do
  client  = get_fb_client
  client.authorization_code = params[:code].to_s
  begin
    access_token = client.access_token! :client_auth_body
    puts client
  rescue Rack::OAuth2::Client::Error => e
    puts "Exception"
    puts e
    puts e.response
  end
  
  cookies[:access_token] = access_token
  
  redirect '/movies'
end

get '/movie/:movie_name' do
  movie_details = fetch_movie(params[:movie_name])
  @movie = movie_details
  haml :movie, :format => :html5
end

post '/watched' do
  url = "http://movies.alagu.net/movie/#{params[:movie]}"
  return movie_watched(params[:movie], cookies[:access_token])
end