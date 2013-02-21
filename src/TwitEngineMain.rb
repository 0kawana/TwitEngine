#!/usr/bin/env ruby
# encoding : utf-8

#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/17
#===========================================================

# 絶対パスでrequire
require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/define')
require File.expand_path(File.dirname(__FILE__) + '/GetOldtime')

# configに登録
Twitter.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = OAUTH_TOKEN
    config.oauth_token_secret = OAUTH_TOKEN_SECRET
end

# access_tokenなどが必要なので、configureより後でrequire
require File.expand_path(File.dirname(__FILE__) + '/classCharacter')

# 前回実行時の時間の取得・生成
old_time = GetOldtime()

# 現在実行時の時間の書き込み
new_time = Time.new
#File.open(DIR_LOG + "/Runtime.log", 'w') do |file|
#    # year,mon,day,hour,min,secの順で書き込み
#    file.print new_time.strftime("%Y,%m,%d,%H,%M,%S")
#end


# メアリの顕現
mary = Character.new(NAME, new_time)

timeline = []
Twitter.home_timeline.each do |tweet|
    # 前回実行時から今回実行時までの間
    if old_time < tweet.created_at and tweet.created_at <= new_time
        # 自分のツイート以外を先頭に格納
        unless tweet.user.screen_name == NAME
            timeline.unshift(tweet)
        end
    else
        # 時間外ならループを抜ける
        break
    end
end

# 応答内容とoptionsを決定
post = mary.dialogue(timeline) #=> Hashの配列

puts post # デバッグ

post.each do |p|
    begin
        # 呟く
        #Twitter.update(p["response"], p["options"])
    rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
        puts "投稿エラー"
    end
end

# フォローフォロワーの整理
# 一番人がいなさそうな午前４時で
if new_time.hour == 4 and new_time.min == 0
    mary.adjust_user
end


