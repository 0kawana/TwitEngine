#!/usr/bin/env ruby
# encoding : utf-8

#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#===========================================================

require 'rubygems'
require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/define.rb')
require File.expand_path(File.dirname(__FILE__) + '/classTwitterControl.rb')
require File.expand_path(File.dirname(__FILE__) + '/classCharacter.rb')

class Mary
    def initialize
        @twit_ctrl = TwitterControl.new
        @old_time = get_oldtime()
        @new_time = get_newtime()
        @character = Character.new(@twit_ctrl, @new_time, ajust_time(0.0))
    end

    # @return [String]
    def tweet
        write_newtime()
        timeline = []
        timeline += @twit_ctrl.get_mentions(@old_time, @new_time, ajust_time(0.0))
        timeline += @twit_ctrl.get_timeline(@old_time, @new_time, ajust_time(0.0))

        posts = @character.dialogue(timeline)
        #@twit_ctrl.tweet_posts(posts)

        html = "Action Successfull!!<BR>
        #{@old_time.mon}/#{@old_time.day},#{@old_time.hour}:#{@old_time.min}:#{@old_time.sec} ~
        #{@new_time.mon}/#{@new_time.day},#{@new_time.hour}:#{@new_time.min}:#{@new_time.sec}"
        return html
    end


    protected
    # @param time [Time or Float]
    # @return [Time or Float]
    def ajust_time(time)
        #time += 9*60*60   #=> heroku(もとがGMTなので)
        return time
    end

    # @return [Time]
    def get_oldtime
        return get_newtime() unless File.exists?("./Runtime.log")

        log = File.read("./Runtime.log").split(",")
        t = Time.local(*log)
        old_time = ajust_time(t.localtime)
        return old_time
    end

    # @return [Time]
    def get_newtime
        time = ajust_time(Time.new)
        return time
    end

    def write_newtime
        File.open("./Runtime.log", 'w') do |f|
            f.print @new_time.strftime("%Y,%m,%d,%H,%M,%S")
        end
    end
end

puts Mary.new.tweet


