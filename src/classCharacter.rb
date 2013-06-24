# encoding : utf-8

#===========================================================
# classCharacter.rb
# Characterクラス
# Emotionクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#===========================================================

require File.expand_path(File.dirname(__FILE__) + '/classResponder.rb')
require File.expand_path(File.dirname(__FILE__) + '/classDictionary.rb')
require File.expand_path(File.dirname(__FILE__) + '/_classTestDictionary.rb')

#=================================================
# Characterクラス
#=================================================
class Character
    MENTION = 0
    REPLY = 1
    MENTION_REPLY = 2

    # @param twit_ctrl [TwitterControl]
    # @param new_time [Time]
    # @param adjust_time [Time or Float]
    def initialize(twit_ctrl, new_time, adjust_time)
        @twit_ctrl = twit_ctrl
        @new_time = new_time
        @adjust_time = adjust_time

        @dictionary = Dictionary.new(@twit_ctrl, @new_time, @adjust_time)
        #@dictionary = TestDictionary.new(@twit_ctrl, @new_time, @adjust_time)  #=> debug

        @resp_regular = RegularResponder.new("Regular", @dictionary)
        @resp_reply = ReplyResponder.new("Reply", @dictionary)
        @resp_mention = MentionResponder.new("Mention", @dictionary)

        @emotion = Emotion.new(@dictionary)
    end

    # @param timeline [Array<Tweet>]
    # @return [Array<Hash>]
    def dialogue(timeline)
        posts = []

        timeline.each do |tweet|
            if tweet.text.include?("@#{NAME}")      # Reply
                # introduce_check(tweet)
                type = search_type(tweet.text, [REPLY, MENTION_REPLY])
                responder = @resp_reply
            else                                    # Mention
                type = search_type(tweet.text, [MENTION, MENTION_REPLY])
                next if type.empty?
                responder = @resp_mention
            end

            response = responder.get_response(tweet, type)
            next if response.empty?
            options = responder.get_options(tweet)
            @dictionary.update_nearlytweet(response)
            posts << {"response" => response, "options" => options}

            unless type.empty?
                # テヘペロッ
                @emotion.update_mood(tweet.user.id.to_s, @dictionary.pattern[type].moods.sample)
            end
        end

        # Regular
        if check_time?()
            response = @resp_regular.get_response
            options = @resp_regular.get_options
            unless response.empty?
                posts << {"response" => response, "options" => options}
            end
            @emotion.adjust_mood()
        end

        # @dictionary.update_users()
        return posts
    end

    def adjust_user
        followers = @twit_ctrl.follower_ids(NAME)
        friends = @twit_ctrl.friend_ids(NAME)
        removes = friends - followers 
        registers = followers - friends
        removes.reverse!
        registers.reverse!

        @dictionary.remove_users(removes)
        @dictionary.regist_users(registers)

        @twit_ctrl.unfollow(removes)
        @twit_ctrl.follow(registers)
    end


    private
    # @param tweet [String]
    # @param tweet [Array<Integer>]
    # @return [String]
    def search_type(text, layers)
        @dictionary.pattern.each_pair do |key, value|
            elem = value.phrases.zip(value.layers)
            elem.each do |phrase, layer|
                next unless layers.include?(layer)
                return key if text =~ /#{phrase}/
            end
        end
        return ""
    end

    # @param tweet [Tweet]
    def introduce_check(tweet)
        if tweet.text =~ /(はじ|初|始)めまして(、|。)?(.*?)です/
            @dictionary.update_user_name(tweet.user.id.to_s, $3)
        end
    end

    # @return [Boolean]
    def check_time?
        # return (@new_time.hour <= 3 || @new_time.hour >= 6)
        return (@new_time.hour <= 3 || @new_time.hour >= 6) && @new_time.min == 0
    end
end

#=================================================
# Emotionクラス
#=================================================
class Emotion
    MOOD_MIN = -30
    MOOD_MAX = 30
    MOOD_RECOVERY = 1

    # @param dict [Dictionary]
    def initialize(dict)
        @dict = dict
    end

    # @param user_key [String]
    # @param val [Integer]
    def update_mood(user_key, val)
        mood = @dict.userdata[user_key].user_mood + val
        mood = MOOD_MAX if mood > MOOD_MAX
        mood = MOOD_MIN if mood < MOOD_MIN
        @dict.update_user_mood(user_key, mood)
    end

    # @note 全ユーザの機嫌値を0に近づける
    def adjust_mood
        @dict.userdata.each_pair do |key, value|
            mood = value.user_mood
            next if mood == 0

            mood -= MOOD_RECOVERY if mood > 0
            mood += MOOD_RECOVERY if mood < 0
            @dict.update_user_mood(key, mood)
        end
    end
end


