require 'rubygems'
require 'fb_graph'
require 'mongo'
require 'json'

def get_fb_client
  fb_auth = FbGraph::Auth.new('341474139245238', '98aa893c894f10e33eb01b3eba1dc835')
  client  = fb_auth.client
  client.redirect_uri = 'http://movies.alagu.net:9393/callback'
  
  client
end

def store_user
  
end