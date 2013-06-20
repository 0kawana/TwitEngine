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
    end

    def configure
        @twitter.configure do |config|
            config.consumer_key       = ENV['CONSUMER_KEY']
            config.consumer_secret    = ENV['CONSUMER_SECRET']
            config.oauth_token        = ENV['OAUTH_TOKEN']
            config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
        end
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
            break unless old_time < created_at || created_at <= new_time
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
            break unless old_time < created_at || created_at <= new_time
            next if tweet.user.screen_name == NAME || check_include?(tweet.text)
            timeline << tweet
        end
        return timeline
    end

    protected
    # @param text [String]
    # @return [Boolean]
    def check_include?(text)
        return text.include?("@") || text.include?("#")
        #if text.include?("@") || text.include?("#")
        #    return true
        #end
        #return false
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

#p TwitterControl.new.configure
#p TwitterControl.new.user(20)
#p TwitterControl.new.user_timeline
#p TwitterControl.new.follower_ids("sebas_m3")
#p TwitterControl.new.friend_ids("sebas_m3")
#p TwitterControl.new.follow(123)
#p TwitterControl.new.unfollow(123)


