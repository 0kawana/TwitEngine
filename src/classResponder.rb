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
    # get_response(Twitter obj, String)
    def get_response(tweet, type)
        return ""
    end

    # get_options(Twitter obj)
    def get_options(tweet)
        return {}
    end

    protected
    # check_response?(String)
    def check_response?(resp)
    end
end

#=================================================
# RegularResponderクラス
#=================================================
class RegularResponder < Responder
    # get_response(nil, nil)
    def get_response(tweet, type)
    end
end


#=================================================
# ReplyResponderクラス
#=================================================
class ReplyResponder < Responder
    # get_response(Twitter obj, String)
    def get_response(tweet, type)
    end

    # get_options(Twitter obj)
    def get_options(tweet)
    end
end

#=================================================
# MentionResponderクラス
#=================================================
class MentionResponder < Responder
    # get_response(Twitter obj, String)
    def get_response(tweet, type)
    end

    # get_options(Twitter obj)
    def get_options(tweet)
    end
end



