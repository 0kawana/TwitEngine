# encoding : utf-8

#===========================================================
# classResponder.rb
# Responderクラス
#  |--ReplyResponderクラス
#  |--RegularResponderクラス
#  |--MentionResponderクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/11
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
    def response(tweet, key, mood)
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
    def response(tweet, key, mood)
        return "#{tweet.text}ってなに？"
    end
end

# 定期ポスト用
class RegularResponder < Responder
    # responseメソッドをオーバーライド
    # 引数は使っていない
    def response(tweet, key, mood)
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
    def response(tweet, key, mood)
        # ここでやりたかったっぽいことは下の方でやってます

=begin
        # メアリの顕現
        mary = Character.new(NAME)
        #よく分からなかったのでここの部分修正頼みます

    if(mary.check_keyword(tweet.text))
    keycheck = mary.check_keyword(tweet.text)
    return keycheck
    else
        @dictionary.random.each do |line|
            resp = "@#{tweet.user.screen_name} " + line
            if check?(resp)
                return resp
            end
        end
    end
        return nil
=end

        begin
            # keyがnilだった場合はエラーがでるので例外処理で回避
            # パターン側と同じキーの中からランダムにphraseを取り出す
            @dictionary.random[key].phrases.shuffle.each do |phrase|
                resp = "@#{tweet.user.screen_name} " + phrase
                # チェックに引っかからなかったらreturn
                if check?(resp)
                    return resp
                end
            end
        rescue
        else
            # keyがnilだったり、どの応答もできないときは例外的な応答
            @dictionary.random["unknown"].phrases.shuffle.each do |phrase|
                resp = "@#{tweet.user.screen_name} " + phrase
                # チェックに引っかからなかったらreturn
                if check?(resp)
                    return resp
                end
            end
        end
        # それでも何も応答できない場合はnilを返す
        return nil
    end

    # set_optionsメソッドをオーバーライド
    def set_options(tweet)
        options = {"in_reply_to_status_id" => tweet.id}
        return options
    end
end

# mention用
class MentionResponder < Responder
    # responseメソッドをオーバーライド
    def response(tweet, key, mood)
        # パターン側と同じキーの中からランダムにphraseを取り出す
        @dictionary.random[key].phrases.shuffle.each do |phrase|
            resp = "@#{tweet.user.screen_name} " + phrase
            # チェックに引っかからなかったらreturn
            if check?(resp)
                return resp
            end
        end

        # ツイートできるものがなければnilを返す
        return nil
    end

    # set_optionsメソッドをオーバーライド
    def set_options(tweet)
        options = {"in_reply_to_status_id" => tweet.id}
        return options
    end
end
