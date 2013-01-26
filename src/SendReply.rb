# encoding : utf-8

#===========================================================
# SendReply.rb
# 他のユーザからのmentionsに対してreplyを送る
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/24
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/Tweet.rb')

def SendReply(old_time, new_time)

    # リプライを配列に格納
    reply = []
    Twitter.mentions.each do |tweet|
        # 前回実行時から今回実行時までの間
        if old_time < tweet.created_at && tweet.created_at <= new_time
            if tweet.user.screen_name != USER_NAME
                reply.unshift(tweet)
            end
        # 時間外ならループを抜ける
        else
            break
        end
    end

    # ディレクトリパスのセット
    dir_keyword = DIR_DATA + "/keyword/"
    dir_tweet   = DIR_DATA + "/tweet/"

    # キーワードを探し出してreplyを送る
    reply.each do |tweet|
        success = false
        # キーワード系(キャラの名前など)
        # パターンとマッチしたら
        if PatternMatch(tweet.text, dir_keyword+"/Keyword.csv")
            # データの中からランダムにテキストを選んでreply
            success = PatternTweet(tweet, dir_tweet+"/Keyword.csv")
        # おやすみ系
        elsif PatternMatch(tweet.text, dir_keyword+"/Sleep.csv")
            success = PatternTweet(tweet, dir_tweet+"/Sleep.csv")
        # おはよう系
        elsif PatternMatch(tweet.text, dir_keyword+"/Wakeup.csv")
            success = PatternTweet(tweet, dir_tweet+"/Wakeup.csv")
        # おかえり系
        elsif PatternMatch(tweet.text, dir_keyword+"/Backhome.csv")
            success = PatternTweet(tweet, dir_tweet+"/Backhome.csv")
        # いってらっしゃい系
        elsif PatternMatch(tweet.text, dir_keyword+"/Gohome.csv")
            success = PatternTweet(tweet, dir_tweet+"/Gohome.csv")
        # おなかすいた系
        elsif PatternMatch(tweet.text, dir_keyword+"/Hungry.csv")
            success = PatternTweet(tweet, dir_tweet+"/Hungry.csv")
        # 疲れた系
        elsif PatternMatch(tweet.text, dir_keyword+"/Tired.csv")
            success = PatternTweet(tweet, dir_tweet+"/Tired.csv")
        end

        # どのキーワードにもマッチしない
        # または、どのキーワードも打ち止め
        if success == false
            # これにも失敗した場合は返信しない
            PatternTweet(tweet, dir_tweet+"/Unknown.csv")
        end
    end

end

# デバッグ用
#SendReply()


