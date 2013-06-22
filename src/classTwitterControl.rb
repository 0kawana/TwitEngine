# encoding : utf-8

#===========================================================
# classTwitterControl.rb
# TwitterControlクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#-----------------------------------------------------------
# Twitter モジュールの制御は全てこのクラスを通して行う
#===========================================================

require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/_moduleTestTwitter.rb')

#=================================================
# TwitterControlクラス
#=================================================
class TwitterControl
    def initialize
        #@twitter = Twitter
        @twitter = TestTwitter
        set_config()
    end

    # @param posts [Array<Hash>]
    def tweet_posts(posts)
        posts.each do |post|
            begin
                @twitter.update(post["response"], post["options"])
            rescue
                # p "Error"
            end
        end
    end

    # @param old_time [Time]
    # @param new_time [Time]
    # @param ajust_time [Time or Float]
    # @return [Array<Tweet>]
    def get_mentions(old_time, new_time, ajust_time)
        mentions = []
        @twitter.mentions.each do |tweet|
            created_at = tweet.created_at + ajust_time
            break unless between_time?(old_time, created_at, new_time)
            mentions << tweet
        end
        return mentions
    end

    # @param old_time [Time]
    # @param new_time [Time]
    # @param ajust_time [Time or Float]
    # @return [Array<Tweet>]
    def get_timeline(old_time, new_time, ajust_time)
        timeline = []
        @twitter.home_timeline.each do |tweet|
            created_at = tweet.created_at + ajust_time
            break unless between_time?(old_time, created_at, new_time)
            next if tweet.user.screen_name == NAME || check_include?(tweet.text)
            timeline << tweet
        end
        return timeline
    end

    # @param name [String]
    # @param options [Hash]
    # @param new_time [Time]
    # @param ajust_time [Time or Float]
    # @return [Array<String>]
    def get_nearlytweet(name, options, new_time, ajust_time)
        before = 23*60*60
        nearly = []
        @twitter.user_timeline(name, options).each do |tweet|
            created_at = tweet.created_at + ajust_time
            break unless between_time?(new_time-before, created_at, new_time)
            nearly << tweet.text
        end
        return nearly
    end

    # @param user_key [Integer]
    # @return [String]
    def get_user_name(user_key)
        return @twitter.user(user_key).name
    end

    private
    def set_config
        @twitter.configure do |config|
            config.consumer_key       = ENV['CONSUMER_KEY']
            config.consumer_secret    = ENV['CONSUMER_SECRET']
            config.oauth_token        = ENV['OAUTH_TOKEN']
            config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
        end
    end

    # @param text [String]
    # @return [Boolean]
    def check_include?(text)
        return text.include?("@") || text.include?("#")
    end

    # @param before [Time]
    # @param base [Time]
    # @param after [Time]
    # @return [Boolean]
    def between_time?(before, base, after)
        return before < base || base <= after
    end

    # def user(id)
    #     return @twitter::user(id).name
    # end

    # def follower_ids(name)
    #     return @twitter::follower_ids(name).ids
    # end

    # def friend_ids(name)
    #     return @twitter::friend_ids(name).ids
    # end

    # def follow(id)
    #     @twitter::follow(id)
    # end

    # def unfollow(id)
    #     @twitter::unfollow(id)
    # end
end


