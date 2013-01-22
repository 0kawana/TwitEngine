# encoding : utf-8

#===========================================================
# GetOldtime.rb
# 前回実行時の時間を取得・生成
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/22
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/define.rb')

def GetOldtime()
    log = File.read(DIR_LOG + "/Runtime.log")
    # 文字列からTimeオブジェクトを生成
    old_time = Time.gm *log.split(",")
    # タイムゾーンをUTCからJSTに変換
    # 変換によって9時間(9*60*60秒)ずれた分をもとに戻す
    old_time = old_time.localtime - 9*60*60
    return old_time
end

# デバッグ用
#p GetOldtime()


