# encoding : utf-8

#===========================================================
# SendMentions.rb
# キーワードに反応してmentionsを送る
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/23
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/PatternMatch.rb')
require File.expand_path(File.dirname(__FILE__) + '/PatternTweet.rb')

def SendMentions(old_time, new_time)

    # TLのツイートを配列に格納
    timeline = []
    Twitter.home_timeline.each do |tweet|
        # 前回実行時から今回実行時までの間
        if old_time < tweet.created_at && tweet.created_at <= new_time
            # 自分以外のツイートとリプライを除いたもののみ
            if tweet.user.screen_name != USER_NAME &&
               !tweet.text.include?("@"+USER_NAME) then
                # 配列の先頭に加えていく
                timeline.unshift(tweet)
            end
        # 時間外ならループを抜ける
        else
            break
        end
    end

    # ディレクトリパスのセット
    dir_keyword = DIR_DATA + "/keyword/"
    dir_tweet   = DIR_DATA + "/tweet/"

    # キーワードを探し出してmentionsを送る
    timeline.each do |tweet|
        # キーワード系(キャラの名前など)
        # パターンとマッチしたら
        if PatternMatch(tweet.text, dir_keyword+"/Keyword.csv")
            # データの中からランダムにテキストを選んでmentions
            PatternTweet(tweet, dir_tweet+"/Keyword.csv")
        # おやすみ系
        elsif PatternMatch(tweet.text, dir_keyword+"/Sleep.csv")
            PatternTweet(tweet, dir_tweet+"/Sleep.csv")
        # おはよう系
        elsif PatternMatch(tweet.text, dir_keyword+"/Wakeup.csv")
            PatternTweet(tweet, dir_tweet+"/Wakeup.csv")
        # おかえり系
        elsif PatternMatch(tweet.text, dir_keyword+"/Backhome.csv")
            PatternTweet(tweet, dir_tweet+"/Backhome.csv")
        # いってらっしゃい系
        elsif PatternMatch(tweet.text, dir_keyword+"/Gohome.csv")
            PatternTweet(tweet, dir_tweet+"/Gohome.csv")
        # おなかすいた系
        elsif PatternMatch(tweet.text, dir_keyword+"/Hungry.csv")
            PatternTweet(tweet, dir_tweet+"/Hungry.csv")
        # 疲れた系
        elsif PatternMatch(tweet.text, dir_keyword+"/Tired.csv")
            PatternTweet(tweet, dir_tweet+"/Tired.csv")
        end
    end
end

# デバッグ用
#SendMentions(old_time, new_time)


