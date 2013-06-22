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
    # @param ajust_time [Time or Float]
    def initialize(twit_ctrl, new_time, ajust_time)
        @twit_ctrl = twit_ctrl
        @new_time = new_time
        @ajust_time = ajust_time
        @dictionary = Dictionary.new(@twit_ctrl, @new_time, @ajust_time)
        #@dictionary = TestDictionary.new(@twit_ctrl, @new_time, @ajust_time)  #=> debug
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
    end

    # @param id_str [String]
    # @param val [Integer]
    def update_mood(id_str, val)
    end

    def ajust_mood
    end
end


