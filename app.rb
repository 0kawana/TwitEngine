require 'sinatra'
require 'src/TwitEngineMain'

get '/' do
    Mary.new.tweet
end

