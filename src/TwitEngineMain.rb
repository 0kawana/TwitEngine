#!/usr/local/bin/ruby
# encoding : utf-8

#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/19
#===========================================================

# 絶対パスでrequire
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/TweetWord.rb')

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


