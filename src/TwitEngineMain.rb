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
require File.expand_path(File.dirname(__FILE__) + '/GetOldtime.rb')

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


# 前回実行時の時間の取得・生成
old_time = GetOldtime()

# 現在実行時の時間の書き込み
new_time = Time.new
File.open(DIR_LOG + "/Runtime.log", 'w') do |file|
    # year,mon,day,hour,min,secの順で書き込み
    file.print new_time.strftime("%Y,%m,%d,%H,%M,%S")
end


if CheckMentions(old_time, new_time)
    # mentionsがきていたらreplyを送る
    #SendReply(old_time, new_time)
end

if CheckKeyword(old_time, new_time)
    # keywordがあったらmentionsを送る
    SendMentions(old_time, new_time)
end

if CheckTime(new_time)
    # 指定した時間であれば定期的なツイートをする
    #RegularTweet(new_time)
end



