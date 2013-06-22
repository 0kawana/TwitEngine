# encoding : utf-8

#===========================================================
# _classTestDictionary.rb
# TestDictionaryクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#-----------------------------------------------------------
# DB に接続できない環境ならこのクラスを使って決め打ち
#===========================================================

require File.expand_path(File.dirname(__FILE__) + '/classDictionary.rb')

#=================================================
# TestDictionaryクラス
#=================================================
class TestDictionary < Dictionary
    # @note Override
    def update_users
        # Dummy
    end

    # @note Override
    def remove_users(users_key)
        # Dummy
    end

    # @note Override
    def regist_users(users_key)
        # Dummy
    end


    private
    # @note Override
    def set_conn
        # Dummy
    end

    # @note Override
    def set_regular
        @regular = [
            "hoge",
            "regular test",
            "こんにちは"
        ]
    end

    # @note Override
    def set_response
        @response["morning"] = EachtypeElem.new
        @response["morning"].add_phrase("おはようございます")
        @response["morning"].add_mood(5)
        @response["thanks"] = EachtypeElem.new
        @response["thanks"].add_phrase("ありがとう")
        @response["thanks"].add_mood(10)
        @response["bad"] = EachtypeElem.new
        @response["bad"].add_phrase("死ね")
        @response["bad"].add_mood(-5)
    end

    # @note Override
    def set_pattern
        @pattern["morning"] = EachtypeElem.new
        @pattern["morning"].add_phrase("おはようございます")
        @pattern["morning"].add_layer(2)
        @pattern["morning"].add_mood(5)
        @pattern["thanks"] = EachtypeElem.new
        @pattern["thanks"].add_phrase("ありがとう")
        @pattern["thanks"].add_layer(1)
        @pattern["thanks"].add_mood(10)
        @pattern["bad"] = EachtypeElem.new
        @pattern["bad"].add_phrase("死ね")
        @pattern["bad"].add_layer(1)
        @pattern["bad"].add_mood(-5)
    end

    # @note Override
    def set_userdata
        @userdata["11111"] = UserElem.new("セバス", 10)
        @userdata["22222"] = UserElem.new("ありすれいかー", 20)
        @userdata["33333"] = UserElem.new("test_user", -10)
    end
end


