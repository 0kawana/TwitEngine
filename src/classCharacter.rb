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
        @emotion = Emotion.new(@dictionary)
    end

    # @param timeline [Array<Tweet>]
    # @return [Array<Hash>]
    def dialogue(timeline)
        posts = []

        posts = [
            {"response" => "hoge", "options" => {}},
            {"response" => "@Sharnoth_Mary かわいい", "options" => {}},
            {"response" => "hoge", "options" => {"in_reply_to" => 1234}},
            {"response" => "@Sharnoth_Mary おはよう", "options" => {"in_reply_to" => 123}}
        ]
        return posts
    end

    def adjust_user
        followers = @twit_ctrl.follower_ids(NAME)
        friends = @twit_ctrl.friend_ids(NAME)
        removes = friends - followers 
        registers = followers - friends

        @dictionary.remove_users(removes)
        @dictionary.regist_users(registers)

        @twit_ctrl.unfollow(removes)
        @twit_ctrl.follow(registers)
    end


    private
    # @param tweet [Tweet]
    # @param tweet [Array<Integer>]
    def search_type(tweet, layers)
    end

    # @return [Boolean]
    def check_time?
    end

    # @return [Boolean]
    def check_introduce?(text)
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
        @dict.update_mood(user_key, mood)
    end

    # @note 全ユーザの機嫌値を0に近づける
    def adjust_mood
        @dict.userdata.each_pair do |key, value|
            mood = value.user_mood
            next if mood == 0

            mood -= MOOD_RECOVERY if mood > 0
            mood += MOOD_RECOVERY if mood < 0
            @dict.update_mood(key, mood)
        end
    end
end


