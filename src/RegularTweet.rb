# encoding : utf-8

#===========================================================
# RegularTweet.rb
# 通常のツイート
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/19
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/Tweet.rb')

def RegularTweet(new_time)
    #texts = File.read(DIR_DATA + "/test.csv").split("\n")
    texts = File.read(DIR_DATA + "/Regular.csv").split("\n")
    # ランダムな内容を返す
    texts.shuffle!
    text = texts[0]

    # optionsの指定
    options = {}

    # 呟く
    Tweet(text, options)

    # この関数単体で動かす場合はトークンを読み込んでないので"投稿エラー"と出ます
    # びっくりしないように!！
    #p text
end

# デバッグ用
#RegularTweet()


