# encoding : utf-8

#===========================================================
# classResponder.rb
# Responderクラス
#  |--RegularResponderクラス
#  |--ReplyResponderクラス
#  |--MentionResponderクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#===========================================================

#=================================================
# Responderクラス
#=================================================
class Responder
    attr_reader :name

    # @param name [String]
    # @param dict [Dictionary]
    def initialize(name, dict)
        @name = name
        @dict = dict
    end

    # @param tweet [Tweet]
    # @param type [String]
    # @return [String]
    def get_response(tweet = nil, type = nil)
        return ""
    end

    # @param tweet [Tweet]
    # @return [Hash]
    def get_options(tweet = nil)
        return {}
    end

    private
    # @param screen_name [String]
    # @param user_name [String]
    # @param user_mood [Integer]
    # @param elem [Array<String, Integer>]
    # @return [String]
    def decide_response(screen_name, user_name, user_mood, elem)
        elem.shuffle.each do |phrase, mood|
            next unless check_mood?(user_mood, mood)
            resp = "@#{screen_name} " + gsub_phrase(phrase, user_name)
            return resp if check_response?(resp)
        end
        return ""
    end

    # @param resp [String]
    # @return [Boolean]
    def check_response?(resp)
        return false if resp.length > 140
        return false if @dict.nearlytweet.include?(resp)
        return true
    end

    # @param phrase [String]
    # @param name [String]
    # @return [String]
    def gsub_phrase(phrase, name)
        return phrase.gsub("<BR>", "\n").gsub("%match%", name)
    end

    # @param user_mood [Integer]
    # @param mood [Integer]
    # @return [Boolean]
    def check_mood?(user_mood, mood)
        if user_mood >= 0
            return 0 <= mood && mood <= user_mood
        else
            return user_mood <= mood && mood < 0
        end
    end
end

#=================================================
# RegularResponderクラス
#=================================================
class RegularResponder < Responder
    # @note Override
    # @param tweet [Tweet]
    # @param type [String]
    # @return [String]
    def get_response(tweet = nil, type = nil)
        @dict.regular.shuffle.each do |phrase|
            return phrase if check_response?(phrase)
        end
        return ""
    end
end


#=================================================
# ReplyResponderクラス
#=================================================
class ReplyResponder < Responder
    # @note Override
    # @param tweet [Tweet]
    # @param type [String]
    # @return [String]
    def get_response(tweet, type)
        type = "unknown" if type.empty?

        user_mood = @dict.userdata[tweet.user.id.to_s].user_mood
        user_name = @dict.userdata[tweet.user.id.to_s].user_name

        elem = @dict.response[type].phrases.zip(@dict.response[type].moods)
        resp = decide_response(tweet.user.screen_name, user_name, user_mood, elem)
        return resp unless resp.empty?

        # type では返せなかった場合
        return "" if type == "unknown"
        elem = @dict.response["unknown"].phrases.zip(@dict.response["unknown"].moods)
        resp = decide_response(tweet.user.screen_name, user_name, user_mood, elem)
        return resp
    end

    # @note Override
    # @param tweet [Tweet]
    # @return [Hash]
    def get_options(tweet)
        options = {"in_reply_to_status_id" => tweet.id}
        return options
    end
end

#=================================================
# MentionResponderクラス
#=================================================
class MentionResponder < Responder
    # @note Override
    # @param tweet [Tweet]
    # @param type [String]
    # @return [String]
    def get_response(tweet, type)
        return "" unless @dict.response.has_key?(type)

        user_mood = @dict.userdata[tweet.user.id.to_s].user_mood
        user_name = @dict.userdata[tweet.user.id.to_s].user_name

        elem = @dict.response[type].phrases.zip(@dict.response[type].moods)
        resp = decide_response(tweet.user.screen_name, user_name, user_mood, elem)
        return resp
    end

    # @note Override
    # @param tweet [Tweet]
    # @return [Hash]
    def get_options(tweet)
        options = {"in_reply_to_status_id" => tweet.id}
        return options
    end
end


