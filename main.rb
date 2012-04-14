require './lib'
require 'sinatra'
require 'pp'

#curl -F 'access_token=AAAE2kaTFCrYBAD0cZC8OtzOqD2kT8QWIHpoaxaGuRyoUZAbJd8RRL4aTvZCSMh8fnMjnc8AErL4PLEbQJQzYKiBuC9zZCZBUaEXHMR7TSJAZDZD' \
#     -F 'movie=http://movies.alagu.net/Oru_Kal_Oru_Kannadi.html' \
#        'https://graph.facebook.com/me/video.watches'
#

get '/' do
  "Hello"
end

get '/auth' do
  client = get_fb_client
  redirect client.authorization_uri(:scope => [:email, :publish_actions, :'user_actions.video'])
end

get '/callback' do
  client  = get_fb_client
  puts "Callback"
  client.authorization_code = params[:code].to_s
  begin
    access_token = client.access_token! :client_auth_body
    puts client
  rescue Rack::OAuth2::Client::Error => e
    puts "Exception"
    puts e
    puts e.response
  end
  
  response.set_cookie "access_token=#{access_token}"
  
  redirect '/movies'
end

get '/movies' do
  "Hello #{request.cookies['access_token']}"
end