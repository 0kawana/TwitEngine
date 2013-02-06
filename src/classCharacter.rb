# encoding : utf-8

#===========================================================
# classCharacter.rb
# Characterクラス
# Emotionクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/05
#===========================================================

require './classResponder'
require './classDictionary'

class Character
    # 初期化
    def initialize(name)
        @name = name

        @dictionary = Dictionary.new
        @emotion = Emotion.new(@dictionary)

        #@resp_what = WhatResponder.new("What", @dictionary)
        @resp_reply = ReplyResponder.new("Reply", @dictionary)
        @resp_regular = RegularResponder.new("Regular", @dictionary)
        #@resp_pattern = PatternResponder.new("Pattern", @dictionary)

        @responder = @resp_reply
    end

    # 呟く内容の配列を返す
    def dialogue(timeline, new_time)
        #@emotion.update(input)
        resp = []
        timeline.each do |tweet|
            if tweet.text.include?("@#{NAME}")
                @responder = @resp_reply
            else
                # なにもなかった場合は飛ばす
                next
            end

            #layer処理をここに挿入
            #layer(tweet.text)

            # 選択したResponderからresとoptionsを受け取る
            res = @responder.response(tweet, @emotion.mood)
            options = @responder.set_options(tweet)
            # resがnilだった場合は飛ばす
            next if res.nil?
            # Responderクラスのクラス変数であるnearly_tweetの更新
            @responder.set_nearly_tweet(res)
            # ハッシュとして追加
            resp.push("response" => res, "options" => options)
        end

        # RegularResponderだけは時間をキーとしていれるので別処理
        if new_time.min == 0
            # テキストは関係ないのでダミーとしてnilを渡す
            res = @resp_regular.response(nil, @emotion.mood)
            options = @resp_regular.set_options(nil)
            # resがnilだった場合は飛ばす
            unless res.nil?
                # ハッシュとして追加
                resp.push("response" => res, "options" => options)
            end
        end
        return resp
    end


    #現在のpattern.txtを使う場合のキーワードチェックとそれに対するreplyの取得
    def check_keyword(tweet)
        @dictionary.pattern.each do |line|
            keywords = line.pattern.split("|")
            #パターンにあうか調べる
            keywords.each do |p|
                #パターンにあう場合はフレーズを返す
                if tweet.include?(p)
                    return line.phrase[0]
                end
            end
        end
    return nil
    end
        

=begin
    #MySQLの宣言
    mysql = Mysql.new()

    #layer処理
    def layer(tweet)
    if(type = check_keyword(tweet,1)){
        #挨拶処理
        #type に oha とか oya とか種類を返してくるので、それにあったリプライ内容を取得する@ResponderサブクラスかReplyResponderの拡張が必要
    }
    if(type = check_keyword(tweet,0)){
        #好感度処理
        #高感度の仕様が固まってないから何とも typeに文字列で-10とか返させて、それを数値に変換した後そのまま高感度の加減処理すればいいかなあ
    }
    end

    #キーワードチェック
    def check_keyword(tweet,layer)
        #tweetにphraseが含まれる要素があればひとつ返す(現在はDB登録順で一番早いもの)
        check = mysql.query("SELECT * FROM keywords where LOCATE(phrase,".tweet.") > 0 and layer = ".layer." limit 1")
        
        #checkがnullでないとき、typeの値を返す
        if(!check){return check[1]}
    end

=end

    # !現在は使っていない
    # 学習した内容を辞書に追加
    def save
        @dictionary.save
    end

    # Responderクラスのインスタンス変数へのアクセサ
    def responder_name
        return @responder.name
    end

    def mood
        return @emotion.mood
    end

    # アクセサを追加
    attr_reader :name
end


# !現在は使っていない
# Characterクラスと一緒に使う
class Emotion
    MOOD_MIN = -15
    MOOD_MAX = 15
    MOOD_RECOVERY = 0.5

    # 初期化
    def initialize(dictionary)
        @dictionary = dictionary
        @mood = 0
    end

    # 機嫌値を変動
    def update(input)
        @dictionary.pattern.each do |ptn_item|
            if ptn_item.match(input)
                adjust_mood(ptn_item.modify)
                break
            end
        end
        if @mood < 0
            @mood += MOOD_RECOVERY
        elsif @mood > 0
            @mood -= MOOD_RECOVERY
        end
    end

    # MAXやMINを超えた場合
    def adjust_mood(val)
        @mood += val
        if @mood > MOOD_MAX
            @mood = MOOD_MAX
        elsif @mood < MOOD_MIN
            @mood = MOOD_MIN
        end
    end

    # アクセサを追加
    attr_reader :mood
end


# !現在は使っていない
def select_random(arr)
    return arr[rand(arr.size)]
end


