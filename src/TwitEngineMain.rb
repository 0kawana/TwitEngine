#!/usr/local/bin/ruby
# encoding : utf-8

#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/05
#===========================================================

# 絶対パスでrequire
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define')
require File.expand_path(File.dirname(__FILE__) + '/GetOldtime')

# configに登録
Twitter.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = OAUTH_TOEKN
    config.oauth_token_secret = OAUTH_TOEKN_SECRET
end

# access_tokenなどが必要なので、configureより後でrequire
require File.expand_path(File.dirname(__FILE__) + '/classCharacter')

# 前回実行時の時間の取得・生成
old_time = GetOldtime()

# 現在実行時の時間の書き込み
new_time = Time.new
File.open(DIR_LOG + "/Runtime.log", 'w') do |file|
    # year,mon,day,hour,min,secの順で書き込み
    file.print new_time.strftime("%Y,%m,%d,%H,%M,%S")
end


# メアリの顕現
mary = Character.new(NAME)

timeline = []
Twitter.home_timeline.each do |tweet|
    # 前回実行時から今回実行時までの間
    if old_time < tweet.created_at && tweet.created_at <= new_time
        # 自分のツイート以外を先頭に格納
        unless tweet.user.screen_name == NAME
            timeline.unshift(tweet)
        end
    # 時間外ならループを抜ける
    else
        break
    end
end

# 応答内容とoptionsを決定
post = mary.dialogue(timeline, new_time) #=> Hashの配列

#puts post # デバッグ

post.each do |p|
    begin
        # 呟く
        Twitter.update(p["response"], p["options"])
    rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
        puts "投稿エラー"
    end
end



