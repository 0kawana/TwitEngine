# encoding : utf-8

#===========================================================
# classResponder.rb
# Responderクラス
#  |--ReplyResponderクラス
#  |--RegularResponderクラス
#  |--MentionResponderクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/03/01
#===========================================================

# 抽象クラス
class Responder
    # 初期化
    def initialize(name, dictionary)
        @name = name
        @dictionary = dictionary
    end

    # 文字列を返す
    def response(tweet, key)
        return ""
    end

    # ハッシュを返す
    def set_options(tweet)
        return {}
    end

    # ツイートする際にエラーが出ないようにチェック
    def check?(resp)
        # 140字以内かどうか
        return false if resp.length > 140
        # 直近15postとかぶっていないか
        return false if @dictionary.nearly_tweet.include?(resp)
        # 機嫌値を満たしているか

        return true
    end

    # phraseの改行とユーザ名を置換
    def correct_phrase(name, phrase)
        return phrase.gsub("<BR>", "\n").gsub("%match%", name)
    end

    # アクセサを追加
    attr_reader :name
end

#=================================================
# Responderクラスのサブクラス
#=================================================

# 定期ポスト用
class RegularResponder < Responder
    # responseメソッドをオーバーライド
    def response(tweet, key)   #=> 引数は使っていない
        # regular辞書からつぶやく
        @dictionary.regular.shuffle.each do |line|
            return line if check?(line)
        end
        return nil
    end
end

# reply用
class ReplyResponder < Responder
    # responseメソッドをオーバーライド
    def response(tweet, key)
        # keyがnilだった場合はunknownにしておく
        key = "unknown" if key.nil?
        # ユーザ情報
        user_mood = @dictionary.userdata[tweet.user.id.to_s].user_mood
        user_name = @dictionary.userdata[tweet.user.id.to_s].user_name
        # パターン側と同じキーの中からランダムにphraseとmoodを取り出す
        @dictionary.response[key].phrases.zip(@dictionary.response[key].mood).shuffle.each do |phrase, mood|
            if user_mood >= 0
                # 0 <= mood <= user_mood以外の範囲であればとばす
                next unless 0 <= mood and mood <= user_mood
            else
                # user_mood <= mood < 0以外の範囲であればとばす
                next unless user_mood <= mood and mood < 0
            end
            resp = "@#{tweet.user.screen_name} " + correct_phrase(user_name, phrase)
            # チェックに引っかからなかったらreturn
            return resp if check?(resp)
        end
        # keyがnilだったり、どの応答もできないときは例外的な応答
        @dictionary.response["unknown"].phrases.shuffle.each do |phrase|
            resp = "@#{tweet.user.screen_name} " + correct_phrase(user_name, phrase)
            # チェックに引っかからなかったらreturn
            return resp if check?(resp)
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
    def response(tweet, key)
        # 今回のresponse辞書にkeyがなかった場合はnilを返す
        return nil unless @dictionary.response.has_key?(key)

        # ユーザ情報
        user_mood = @dictionary.userdata[tweet.user.id.to_s].user_mood
        user_name = @dictionary.userdata[tweet.user.id.to_s].user_name
        # パターン側と同じキーの中からランダムにphraseを取り出す
        @dictionary.response[key].phrases.zip(@dictionary.response[key].mood).shuffle.each do |phrase, mood|
            if user_mood >= 0
                # 0 < mood <= user_mood以外の範囲であればとばす
                next unless 0 <= mood and mood <= user_mood
            else
                # user_mood <= mood < 0以外の範囲であればとばす
                next unless user_mood <= mood and mood < 0
            end
            resp = "@#{tweet.user.screen_name} " + correct_phrase(user_name, phrase)
            # チェックに引っかからなかったらreturn
            return resp if check?(resp)
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


