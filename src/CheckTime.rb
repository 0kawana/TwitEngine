# encoding : utf-8

#===========================================================
# CheckTime.rb
# 定期的なツイートをする時間かどうかをチェック
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/19
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
#require File.expand_path(File.dirname(__FILE__) + '/define.rb')

def CheckTime(new_time)
    hour = new_time.hour
    min = new_time.min

    if min == 0
        # ??時00分の場合のみtrue
        return true
    end
    return false
end

# デバッグ用
#p CheckTime()


