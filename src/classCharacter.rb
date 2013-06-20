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

#=================================================
# Characterクラス
#=================================================
class Character
    # initialize(ControlTwitter obj, Time obj)
    def initialize(ctrl_twit, new_time)
    end

    # dialogue(Array[Twitter obj])
    def dialogue(timeline)
    end

    protected
    # search_type(Twitter obj, Array[Int])
    def search_type(tweet, layers)
    end

    # check_time?
    def check_time?
    end

    # check_introduce?(String)
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

    # initialize(Dictionary obj)
    def initialize(dict)
    end

    # update_mood(id_str, val)
    def update_mood(id_str, val)
    end

    # ajust_mood
    def ajust_mood
    end
end


