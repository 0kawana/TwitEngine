# encoding : utf-8

#===========================================================
# CheckKeyword.rb
# TLに反応するようなキーワードが呟かれているかをチェック
#-----------------------------------------------------------
# Author : AliceRaker
# 2013/02/02
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
#require File.expand_path(File.dirname(__FILE__) + '/define.rb')


# 本当にキーワードが存在するかどうかは調べなくていいです
# 自分のツイートと、誰かからのリプライ以外があるかどうかを調べてください
# すべて調べていたら処理が重くなるのと、SendMentions.rbの方と処理がかぶるので

def CheckKeyword(old_time, new_time)
    # old_time以上、new_time未満のtimelineにkeywordにかかるものがあるかどうか判定

=begin
    #keywordが含まれるかどうかチェック
    keywords=[]
    data=[]
    Dir::glob("../data/keyword/*.csv").each{|filename|
    	File.read(filename).split("\n").each do |data|
    		keywords.unshift(data)
		end
}
=end
    Twitter.home_timeline.each do |tweet|
        # 前回実行時から今回実行時までの間
        if old_time < tweet.created_at && tweet.created_at <= new_time
            # mentionと自分のツイート以外に存在するときtrueを返す
            if tweet.user.screen_name != USER_NAME &&
               !tweet.text.include?("@"+USER_NAME) then
    					return true
            end
        # 時間外ならループを抜ける
        else
            break
        end
    end

end

# デバッグ用
#p CheckKeyword()


