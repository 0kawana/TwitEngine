# encoding : utf-8

#===========================================================
# classDictionary.rb
# Dictionaryクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#===========================================================

require 'pg'

#=================================================
# Dictionaryクラス
#=================================================
class Dictionary
    attr_reader :regular, :response, :pattern, :userdata, :nearlytweet

    # @param twit_ctrl [TwitterControl]
    # @param new_time [Time]
    # @param ajust_time [Time or Float]
    def initialize(twit_ctrl, new_time, ajust_time)
        @twit_ctrl = twit_ctrl
        @new_time = new_time
        @ajust_time = ajust_time
        @conn = nil
        @regular = []
        @response = {}
        @pattern = {}
        @userdata = {}
        @nearlytweet = []

        set_conn()
        set_init()
    end

    # @param text [String]
    def update_nearlytweet(text)
        @nearlytweet.unshift(text)
        @nearlytweet.pop if @nearlytweet.size > 15
    end

    protected
    def set_conn
        @conn = PGconn.connect('localhost', 5432, '', '', 'mary_db', 'gembaf', 'hoge')
    end

    # @param query [String]
    # @return [Array<PG::Result>]
    def db_connect(query)
        res = @conn.exec(query)
        return res.to_a
    end

    def set_init
        set_regular()
        set_response()
        set_pattern()
        set_userdata()
        set_nearlytweet()
    end

    def set_regular
        query = "SELECT phrase FROM regular WHERE hour=#{@new_time.hour} AND exist='t'"
        res = db_connect(query)
        if res.empty?
            query = "SELECT phrase FROM regular WHERE hour=-1 AND exist='t'"
            res = db_connect(query)
        end
        res.each do |row|
            @regular << row["phrase"]
        end
    end

    def set_response
        i = 0
        while i <= 21
            if i <= @new_time.hour && @new_time.hour < i+3
                act_time = "act_time%02d_%02d" % [i, i+3]
            end
            i += 3
        end

        query = "SELECT type, phrase, mood FROM response WHERE #{act_time}='t' AND exist='t'"
        res = db_connect(query)
        res.each do |row|
            type = row["type"]
            phrase = row["phrase"]
            mood = row["mood"].to_i
            @response[type] = EachtypeElem.new unless @response.has_key?(type)
            @response[type].add_phrase(phrase)
            @response[type].add_mood(mood)
        end
    end

    def set_pattern
        query = "SELECT type, phrase, layer, mood FROM pattern WHERE exist='t'"
        res = db_connect(query)
        res.each do |row|
            type = row["type"]
            phrase = row["phrase"]
            layer = row["layer"].to_i
            mood = row["mood"].to_i
            @pattern[type] = EachtypeElem.new unless @pattern.has_key?(type)
            @pattern[type].add_phrase(phrase)
            @pattern[type].add_layer(layer)
            @pattern[type].add_mood(mood)
        end
    end

    def set_userdata
        query = "SELECT user_key, user_name, user_mood FROM userdata WHERE exist='t'"
        res = db_connect(query)
        res.each do |row|
            user_key = row["user_key"]
            user_name = row["user_name"]
            user_mood = row["user_mood"].to_i
            @userdata[user_key] = UserElem.new(user_name, user_mood)
        end
    end

    def set_nearlytweet
        @nearlytweet += @twit_ctrl.get_nearlytweet(NAME, {"count" => 15}, @new_time, @ajust_time)
    end
end


#=================================================
# EachtypeElemクラス
#=================================================
class EachtypeElem
    attr_reader :phrases, :layers, :moods

    def initialize
        @phrases = []
        @layers = []
        @moods = []
    end

    # @param phrase [String]
    def add_phrase(phrase)
        @phrases << phrase
    end

    # @param layer [Integer]
    def add_layer(layer)
        @layers << layer
    end

    # @param mood [String]
    def add_mood(mood)
        @moods << mood
    end
end

#=================================================
# UserElemクラス
#=================================================
class UserElem
    attr_reader :user_name, :user_mood

    # @param name [String]
    # @param mood [Integer]
    def initialize(name, mood)
        @user_name = name
        @user_mood = mood
    end
end


