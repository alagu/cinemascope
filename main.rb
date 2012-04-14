require 'rubygems'
require 'sinatra'

#curl -F 'access_token=AAAE2kaTFCrYBAD0cZC8OtzOqD2kT8QWIHpoaxaGuRyoUZAbJd8RRL4aTvZCSMh8fnMjnc8AErL4PLEbQJQzYKiBuC9zZCZBUaEXHMR7TSJAZDZD' \
#     -F 'movie=http://movies.alagu.net/Oru_Kal_Oru_Kannadi.html' \
#        'https://graph.facebook.com/me/video.watches'
#
get '/' do
  "Hello"
end