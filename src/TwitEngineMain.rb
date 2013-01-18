/usr/bin/ruby-1.9.3
#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/18
#===========================================================

require 'rubygems'
require 'twitter'
require './define.rb'
require './TweetWord.rb'

# configに登録
Twitter.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = OAUTH_TOEKN
    config.oauth_token_secret = OAUTH_TOEKN_SECRET
end

# 呟く内容を格納
tweet = TweetWord()

begin
    # 呟く
    Twitter.update(tweet)
rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
    puts "投稿エラー"
else
end


