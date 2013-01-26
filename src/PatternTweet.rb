# encoding : utf-8

#===========================================================
# PatternTweet.rb
# 指定されたデータからランダムにツイート
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/24
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/Tweet.rb')

def PatternTweet(tweet, filename)

    # ファイルが存在するかチェック
    unless File.exists?(filename)
        return false
    end

    # ランダムな内容を送る
    options = {"in_reply_to_status_id" => tweet.id}
    texts = File.read(filename).split("\n")
    # 配列をシャッフル
    texts.shuffle!
    texts.each do |text|
        post = "@#{tweet.user.screen_name} #{text}"
        # ツイートに成功するまで続ける
        if Tweet(post, options)
            # ツイートに成功
            return true
        end
    end

    # すべて失敗した場合
    return false
end

# デバッグ用
#PatternTweet()


