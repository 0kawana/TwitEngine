# encoding : utf-8

#===========================================================
# classCharacter.rb
# Characterクラス
# Emotionクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/21
#===========================================================

require File.expand_path(File.dirname(__FILE__) + '/classResponder')
require File.expand_path(File.dirname(__FILE__) + '/classDictionary')

class Character
    # 初期化
    def initialize(name, new_time)
        @name = name
        @new_time = new_time

        @dictionary = Dictionary.new(@new_time)
        @emotion = Emotion.new(@dictionary)

        @resp_reply = ReplyResponder.new("Reply", @dictionary)
        @resp_regular = RegularResponder.new("Regular", @dictionary)
        @resp_mention = MentionResponder.new("Mention", @dictionary)
    end

    # 呟く内容の配列を返す
    def dialogue(timeline)
        # layerの定数
        mention_only = 0
        reply_only = 1
        mention_and_reply = 2

        resp = []
        timeline.each do |tweet|
            @responder = nil        # 初期値はnil
            # @responderとkeyの決定
            if tweet.text.include?("@#{NAME}")    # replyの場合
                if tweet.text =~ /(はじ|初|始)めまして。(.*?)です。/
                    @dictionary.update_name(tweet.user.id.to_s, $2)
                end
                # replyの場合は応答できるものがなくても構わないのでcheck_keywordはif文の中へ
                key = check_keyword(tweet, [reply_only, mention_and_reply])
                @responder = @resp_reply
            elsif key = check_keyword(tweet, [mention_only, mention_and_reply])   # mentionの場合
                @responder = @resp_mention
            end

            # 上記のどれにも引っかからなかった場合はとばす
            next if @responder.nil?

            # 選択したResponderからresとoptionsを受け取る
            res = @responder.response(tweet, key)
            options = @responder.set_options(tweet)
            # resがnilだった場合は飛ばす
            next if res.nil?
            # nearly_tweetの更新
            @dictionary.set_nearly_tweet(res)
            # ハッシュとして追加
            resp.push("response" => res, "options" => options)

            # 機嫌値の変動
            unless key.nil?
                @emotion.update(tweet.user.id.to_s, @dictionary.pattern[key].mood)
            end
        end

        # RegularResponderだけは時間をキーとしていれるので別処理
        # 3~6時以外で1時間に1度動作
        if (@new_time.hour <= 3 or @new_time.hour >= 6) and @new_time.min == 0 then
            # 引数は関係ないのでnilを渡す
            res = @resp_regular.response(nil, nil)
            # resがnilだった場合は飛ばす
            unless res.nil?
                # ハッシュとして追加
                resp.push("response" => res, "options" => {})
            end
            # 機嫌値のリカバリー
            @emotion.adjust_mood
        end

        # 最後に全ユーザ情報を更新
        @dictionary.update_userdata

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
                return key if tweet.text.include?(phrase)
            end
        end
        return nil
    end

    # フォローフォロワーの整理
    def adjust_user
        followers = Twitter.follower_ids(NAME).ids  #=> フォロワー
        friends = Twitter.friend_ids(NAME).ids      #=> フォロー
        removes = friends - followers      #=> リムーブ対象
        registers = followers - friends    #=> フォロー対象
        # DBからユーザを削除
        @dictionary.remove_user(removes)
        # DBに新しいユーザを追加
        @dictionary.register_user(registers)
        # 一方的にフォローしているユーザはリムーブ
        removes.each do |user|
            Twitter.unfollow(user)
        end
        # 一方的にフォローされているユーザはフォロー
        registers.each do |user|
            Twitter.follow(user)
        end
    end

    # Responderクラスのインスタンス変数へのアクセサ
    def responder_name
        return @responder.name
    end

    # アクセサを追加
    attr_reader :name
end

#=================================================
# Emotionクラス
#=================================================
class Emotion
    MOOD_MIN = -30
    MOOD_MAX = 30
    MOOD_RECOVERY = 1

    # 初期化
    def initialize(dictionary)
        @dictionary = dictionary
    end

    # 機嫌値を変動
    def update(user_key, val)
        mood = @dictionary.userdata[user_key].user_mood + val
        if mood > MOOD_MAX
            mood = MOOD_MAX
        elsif mood < MOOD_MIN
            mood = MOOD_MIN
        end
        @dictionary.update_mood(user_key, mood)
    end

    # 全ユーザの機嫌値を0に近づける
    def adjust_mood
        @dictionary.userdata.each_pair do |key, value|
            if value.user_mood > 0
                @dictionary.update_mood(key, value.user_mood - MOOD_RECOVERY)
            elsif value.user_mood < 0
                @dictionary.update_mood(key, value.user_mood + MOOD_RECOVERY)
            end
        end
    end

    # アクセサを追加
    attr_reader :mood
end


