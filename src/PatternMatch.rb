# encoding : utf-8

#===========================================================
# PatternMatch.rb
# 指定されたデータと要素が部分一致するかどうかを調べる
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/22
#===========================================================

# TwitEngineMain.rbから呼び出す場合は必要ない
# このファイル単体で動かすときにはrequireが必要
require File.expand_path(File.dirname(__FILE__) + '/define.rb')

def PatternMatch(elem, filename)
    data = File.read(filename).split("\n")
    data.each do |pattern|
        if elem.include?(pattern)
            return true
        end
    end
    return false
end

# デバッグ用
#p PatternMatch()


