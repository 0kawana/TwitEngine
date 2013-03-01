# encoding : utf-8

#===========================================================
# classDictionary.rb
# Dictionaryクラス
# Itemクラス
#  |--PatternItemクラス
#  |--ResponseItemクラス
# UserItemクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/21
#===========================================================

require 'pg'

class Dictionary
    # 初期化
    def initialize(new_time)
        # DBからの読み込み
        @conn = PGconn.connect(ENV['HOST'], 5432, '', '', ENV['DB_NAME'], ENV['USER_NAME'], ENV['PASSWORD'])

        # reply, mention用辞書
        @response = {}
        # act_timeの決定
        case new_time.hour
        when 0...3
            act_time = "act_time00_03"
        when 3...6
            act_time = "act_time03_06"
        when 6...9
            act_time = "act_time06_09"
        when 9...12
            act_time = "act_time09_12"
        when 12...15
            act_time = "act_time12_15"
        when 15...18
            act_time = "act_time15_18"
        when 18...21
            act_time = "act_time18_21"
        when 21...24
            act_time = "act_time21_24"
        end
        res = @conn.exec("SELECT type, phrase, mood FROM response WHERE #{act_time}='t' and exist='t'")
        res.each do |line|
            type = line["type"]
            phrase = line["phrase"]
            mood = line["mood"].to_i
            if @response.has_key?(type)     # typeがすでに存在している場合
                @response[type].add_phrase(phrase)
                @response[type].add_mood(mood)
            else        # 存在していない場合はResponseItemオブジェクトを生成
                @response[type] = ResponseItem.new(phrase, mood)
            end
        end

        # 定期post用辞書
        @regular = []
        # 現在実行時の時間だけの特殊な定期ポストを取得
        res = @conn.exec("SELECT phrase FROM regular WHERE hour=#{new_time.hour} AND exist='t'")
        if res.to_a.empty?
            # なければワイルドカードのものを取得
            res = @conn.exec("SELECT phrase FROM regular WHERE hour=-1 AND exist='t'")
        end
        res.each do |line|
            phrase = line["phrase"]
            @regular.push(phrase)
        end

        # パターン照合用辞書
        @pattern = {}
        res = @conn.exec("SELECT type, phrase, layer, mood FROM pattern WHERE exist='t'")
        res.each do |line|
            type = line["type"]
            phrase = line["phrase"]
            layer = line["layer"].to_i
            mood = line["mood"].to_i
            if @pattern.has_key?(type)     # typeがすでに存在している場合
                @pattern[type].add_phrase(phrase)
            else        # 存在していない場合はPatternItemオブジェクトを生成
                @pattern[type] = PatternItem.new(phrase, layer, mood)
            end
        end

        @userdata = {}
        res = @conn.exec("SELECT user_key, user_name, user_mood FROM userdata WHERE exist='t'")
        res.each do |line|
            user_key = line["user_key"]
            user_name = line["user_name"]
            user_mood = line["user_mood"].to_i
            @userdata[user_key] = UserItem.new(user_name, user_mood)
        end

        # 自分自身の直近15postを24時間前までの間で取得
        # 24時間経てば同じpostができるので
        @nearly_tweet = []
        before = 24 * 60 * 60  #=> 24時間前
        Twitter.user_timeline(NAME, "count"=>15).each do |tweet|
            created_at = tweet.created_at + 9*60*60
            if new_time-before < created_at and created_at <= new_time
                @nearly_tweet.push(tweet.text)
            else
                break
            end
        end
    end

    # @nearly_tweetの更新
    def set_nearly_tweet(text)
        # 先頭に一番新しいものを追加
        @nearly_tweet.unshift(text)
        # sizeが15post分より大きければ一番古いものを消去
        if @nearly_tweet.size > 15
            @nearly_tweet.pop
        end
    end

    # ユーザごとの名前を更新
    def update_name(user_key, name)
        @userdata[user_key].update_name(name)
    end

    # ユーザごとの機嫌値を更新
    def update_mood(user_key, mood)
        @userdata[user_key].update_mood(mood)
    end

    # 全ユーザ情報を更新
    def update_userdata
        @userdata.each_pair do |key, value|
            @conn.exec("UPDATE userdata
                        SET user_name='#{value.user_name}', user_mood='#{value.user_mood}'
                        WHERE user_key='#{key}' AND exist='t'")
        end
    end

    # DBからユーザを削除
    def remove_user(users)
        users.each do |user|
            @conn.exec("UPDATE userdata SET exist='f' WHERE user_key=#{user}")
        end
    end

    # DBに新しいユーザを追加
    def register_user(users)
        users.each do |user|
            # ユーザを探す
            res = @conn.exec("SELECT * from userdata WHERE user_key=#{user}")
            if res.to_a.empty?
                # 登録されていなかったら登録
                name = Twitter.user(user).name
                @conn.exec("INSERT INTO userdata VALUES(#{user}, '#{name}', 0, 0, 't')")
            else
                # 一旦登録されていたら存在フラグをONにしてUPDATE
                @conn.exec("UPDATE userdata SET exist='t' WHERE user_key='#{user}'")
            end
        end
    end

    # アクセサの追加
    attr_reader :response, :regular, :pattern, :userdata, :nearly_tweet
end


#=================================================
# Itemクラス
#=================================================
# 抽象クラス
class Item
    # 初期化
    def initialize(phrase)
        @phrases = [phrase]
    end

    # phrasesに追加
    def add_phrase(phrase)
        @phrases.push(phrase)
    end

    # アクセサの追加
    attr_reader :phrases
end

# @pattern用
class PatternItem < Item
    # 初期化
    def initialize(phrase, layer, mood)
        super(phrase)
        @layer = layer
        @mood = mood
    end

    # アクセサの追加
    attr_reader :layer, :mood
end

# @response用
class ResponseItem < Item
    # 初期化
    def initialize(phrase, mood)
        super(phrase)
        @mood = [mood]
    end

    # moodに追加
    def add_mood(mood)
        @mood.push(mood)
    end

    # アクセサの追加
    attr_reader :mood
end

#=================================================
# UserItemクラス
#=================================================
class UserItem
    def initialize(user_name, user_mood)
        @user_name = user_name
        @user_mood = user_mood
    end

    # ユーザ名の更新
    def update_name(name)
        @user_name = name
    end

    # 機嫌値の更新
    def update_mood(mood)
        @user_mood = mood
    end

    # アクセサの追加
    attr_reader :user_name, :user_mood
end


