# encoding : utf-8

#===========================================================
# classResponder.rb
# Responderクラス
#  |--WhatResponderクラス
#  |--ReplyResponderクラス
#  |--RegularResponderクラス
#  |--PatternResponderクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/05
#===========================================================

class Responder
    # 自分自身の直近15postを取得
    @@nearly_tweet = []
    Twitter.user_timeline(NAME, "count"=>15).each do |tweet|
        @@nearly_tweet.push(tweet.text)
    end

    # 初期化
    def initialize(name, dictionary)
        @name = name
        @dictionary = dictionary
    end

    # 文字列を返す
    def response(tweet, mood)
        return ""
    end

    # ハッシュを返す
    def set_options(tweet)
        return {}
    end

    # @@nearly_tweetを更新
    def set_nearly_tweet(text)
        # 一番古いものを消去
        @@nearly_tweet.pop
        # 先頭に一番新しいものを追加
        @@nearly_tweet.unshift(text)
    end

    # ツイートする際にエラーが出ないようにチェック
    def check?(resp)
        # 140字以内かどうか
        if resp.length > 140
            return false
        end

        # 直近15postとかぶっていないか
        @@nearly_tweet.each do |line|
            if line == resp
                return false
            end
        end

        return true
    end

    # アクセサを追加
    attr_reader :name
end

#=================================================
# Responderクラスのサブクラス
#=================================================

# !現在は使っていない
class WhatResponder < Responder
    def response(tweet, mood)
        return "#{tweet.text}ってなに？"
    end
end

# 定期ポスト用
class RegularResponder < Responder
    # responseメソッドをオーバーライド
    # tweetは使っていない
    def response(tweet, mood)
        @dictionary.regular.each do |line|
            if check?(line)
                return line
            end
        end
        return nil
    end
end

# reply用
class ReplyResponder < Responder
    # responseメソッドをオーバーライド
    def response(tweet, mood)
        @dictionary.random.each do |line|
            resp = "@#{tweet.user.screen_name} " + line
            if check?(resp)
                return resp
            end
        end
        return nil
    end

    # set_optionsメソッドをオーバーライド
    def set_options(tweet)
        options = {"in_reply_to_status_id" => tweet.id}
        return options
    end

end

# !現在は使っていない
class PatternResponder < Responder
    def response(tweet, mood)
        @dictionary.pattern.each do |ptn_item|
            if m = ptn_item.match(tweet.text)
                resp = ptn_item.choice(mood)
                next if resp.nil?
                return resp.gsub(/%match%/, m.to_s)
            end
        end
        return select_random(@dictionary.regular)
    end
end


