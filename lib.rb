require 'rubygems'
require 'fb_graph'
require 'mongo'
require 'json'
require 'rest_client'
require 'pp'

def get_fb_client
  fb_auth = FbGraph::Auth.new('341474139245238', '98aa893c894f10e33eb01b3eba1dc835')
  client  = fb_auth.client
  client.redirect_uri = 'http://movies.alagu.net/callback'
  
  client
end

def movie_watched(url, access_token)
  me = FbGraph::User.me(access_token)
  url = "https://graph.facebook.com/me/video.watches"
  movie = url
  
  begin
    response = RestClient.post url, :access_token => access_token, :movie => movie
  rescue RestClient::BadRequest => error
    redirect '/auth'
    puts error.inspect
  end
  
  "I noted it for you"
end

def fetch_movie(movie)
  movie_url   = "http://dbpedia.org/data/#{movie}.json"
  
  movie_json  = JSON.parse(RestClient.get(movie_url))
  if movie_json.empty?
    halt "Could not find such movie"
  end
  
  movie_json  = movie_json["http://dbpedia.org/resource/#{movie}"]
  
  name  = movie_json['http://dbpedia.org/property/name'].first['value']
  image = movie_json['http://xmlns.com/foaf/0.1/depiction'].first['value']
  image.gsub!('/commons/','/en/')
  desc  = movie_json['http://dbpedia.org/ontology/abstract'].first['value']
  
  {:name => name, :image => image, :desc => desc}
end