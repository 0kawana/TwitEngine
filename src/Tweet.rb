# encoding : utf-8

#===========================================================
# Tweet.rb
# 実際に呟く
#-----------------------------------------------------------
# Author : gembaf
# 2013/01/19
#===========================================================

def Tweet(tweet)
    begin
        # 呟く
        Twitter.update(tweet)
    rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
        puts "投稿エラー"
    else
    end
end

