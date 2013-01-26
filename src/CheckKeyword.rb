# encoding : utf-8

#===========================================================
# CheckKeyword.rb
# TLに反応するようなキーワードが呟かれているかをチェック
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/26
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
#require File.expand_path(File.dirname(__FILE__) + '/define.rb')


# 本当にキーワードが存在するかどうかは調べなくていいです
# 自分のツイートと、誰かからのリプライ以外があるかどうかを調べてください
# すべて調べていたら処理が重くなるのと、SendMentions.rbの方と処理がかぶるので

def CheckKeyword(old_time, new_time)
    # old_time以上、new_time未満でお願いします
    return true
end

# デバッグ用
#p CheckKeyword()


