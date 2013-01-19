# encoding : utf-8

#===========================================================
# SendReply.rb
# 他のユーザからのmentionsに対してreplyを送る
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/19
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/../mygems/twitter-4.4.4/lib/twitter')
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/Tweet.rb')

def SendReply()
    texts = File.read(DIR_DATA + "/test.csv").split("\n")
    # ランダムな内容をリプライ
    texts.shuffle!
    text = "@mary_bot_test " + texts[0] + " #reply_test"

    # 呟く
    Tweet(text)

    # この関数単体で動かす場合はトークンを読み込んでないので"投稿エラー"と出ます
    # びっくりしないように!！
    #p text
end

# デバッグ用
#SendReply()


