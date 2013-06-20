require 'sinatra'
require 'src/TwitEngineMain.rb'

get '/' do
    Mary.new.tweet
end

