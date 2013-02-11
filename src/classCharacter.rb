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
    def initialize(name, new_time)
        @name = name
        @new_time = new_time

        @dictionary = Dictionary.new(@new_time)
        @emotion = Emotion.new(@dictionary)

        #@resp_what = WhatResponder.new("What", @dictionary)
        @resp_reply = ReplyResponder.new("Reply", @dictionary)
        @resp_regular = RegularResponder.new("Regular", @dictionary)
        #@resp_pattern = PatternResponder.new("Pattern", @dictionary)

        @responder = @resp_reply
    end

    # 呟く内容の配列を返す
    def dialogue(timeline)
        #@emotion.update(input)
        resp = []
        timeline.each do |tweet|
            @responder = nil        # 初期値はnil
            if tweet.text.include?("@#{NAME}")    # replyの場合
                # replyの場合は応答できるものがなくても構わないのでcheck_keywordはif文の中へ
                key = check_keyword(tweet, [1, 2])
                @responder = @resp_reply
            elsif key = check_keyword(tweet, [0, 2])   # mentionの場合
                @responder = @resp_mention
            end

            # 上記のどれにも引っかからなかった場合はとばす
            next if @responder.nil?

            # 選択したResponderからresとoptionsを受け取る
            res = @responder.response(tweet, key, @emotion.mood)
            options = @responder.set_options(tweet)
            # resがnilだった場合は飛ばす
            next if res.nil?
            # Responderクラスのクラス変数であるnearly_tweetの更新
            @responder.set_nearly_tweet(res)
            # ハッシュとして追加
            resp.push("response" => res, "options" => options)
        end

        # RegularResponderだけは時間をキーとしていれるので別処理
        if @new_time.min == 0
            # 引数は関係ないのでnilを渡す
            res = @resp_regular.response(nil, nil)
            options = @resp_regular.set_options(nil)
            # resがnilだった場合は飛ばす
            unless res.nil?
                # ハッシュとして追加
                resp.push("response" => res, "options" => options)
            end
        end

        return resp
    end


    # 指定されたlayerのなかからキーワードを探してkeyを返す
    def check_keyword(tweet, layers)
        # ハッシュを走査
        @dictionary.pattern.each_pair do |key, ptn_item|
            # 指定されていないlayerの場合はとばす
            next unless layers.include?(ptn_item.layer)
            ptn_item.phrases.each do |phrase|
                # マッチしていたらkeyを返す
                if tweet.text.include?(phrase)
                    return key
                end
            end
        end
        return nil
    end


=begin
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
=end

# MySQL関連の処理はDictionaryクラスへ移りました
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


