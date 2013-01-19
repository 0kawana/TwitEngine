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

require File.expand_path(File.dirname(__FILE__) + '/Tweet.rb')

require File.expand_path(File.dirname(__FILE__) + '/SendReply.rb')
require File.expand_path(File.dirname(__FILE__) + '/SendMentions.rb')
require File.expand_path(File.dirname(__FILE__) + '/RegularTweet.rb')

require File.expand_path(File.dirname(__FILE__) + '/CheckMentions.rb')
require File.expand_path(File.dirname(__FILE__) + '/CheckKeyword.rb')
require File.expand_path(File.dirname(__FILE__) + '/CheckTime.rb')


# configに登録
Twitter.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = OAUTH_TOEKN
    config.oauth_token_secret = OAUTH_TOEKN_SECRET
end


if CheckMentions()
    # mentionsがきていたらreplyを送る
    #SendReply()
end

if CheckKeyword()
    # keywordがあったらmentionsを送る
    #SendMentions()
end

if CheckTime()
    # 指定した時間であれば定期的なツイートをする
    RegularTweet()
end



