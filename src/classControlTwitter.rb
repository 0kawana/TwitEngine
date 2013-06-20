# encoding : utf-8

#===========================================================
# classControlTwitter.rb
# ControlTwitterクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#===========================================================

require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/_moduleTestTwitter.rb')

#=================================================
# ControlTwitterクラス
#=================================================
class ControlTwitter
    def initialize
        #@twitter = Twitter
        @twitter = TestTwitter
    end

    def user_timeline
        return @twitter::user_timeline("sebas", {})
    end

    def user(id)
        return @twitter::user(id).name
    end

    def follower_ids(name)
        return @twitter::follower_ids(name).ids
    end

    def friend_ids(name)
        return @twitter::friend_ids(name).ids
    end

    def follow(id)
        return @twitter::follow(id)
    end

    def unfollow(id)
        return @twitter::unfollow(id)
    end
end

#p ControlTwitter.new.user(20)
#p ControlTwitter.new.user_timeline
#p ControlTwitter.new.follower_ids("sebas_m3")
#p ControlTwitter.new.friend_ids("sebas_m3")
#p ControlTwitter.new.follow(123)
#p ControlTwitter.new.unfollow(123)


