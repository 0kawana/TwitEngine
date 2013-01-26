# encoding : utf-8

#===========================================================
# Tweet.rb
# 実際に呟く
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/23
#===========================================================

def Tweet(tweet, options)
    begin
        # 呟く
        Twitter.update(tweet, options)
    rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
        puts "投稿エラー"
        return false
    else
        return true
    end
end

