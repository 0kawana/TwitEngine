# encoding : utf-8

#===========================================================
# _moduleTestTwitter.rb
# TestTwitterモジュール
#-----------------------------------------------------------
# Author : gembaf
# 2013/06/17
#-----------------------------------------------------------
# 本家のTwitterモジュールの使用する部分を再現
#===========================================================

#=================================================
# TestTwitterモジュール
#=================================================

module TestTwitter
    # @ex Twitter.configure
    def configure
        # Dummy
        # 本来はyield
    end

    # @ex Twitter.update("hogehoge", {"in_reply_to" => 12345})
    # @param response [String]
    # @param options [Hash]
    def update(response, options)
        puts "#{response}, #{options}"
    end

    # @ex Twitter.home_timeline("count" => 15)
    # @param options [Hash]
    # @return [Array<Tweet>]
    def home_timeline(options = {})
        data = [
            {"text" => "メアリ", "created_at" => Time.new, "name" => "Sharnoth_Mary"},
            {"text" => "おはよう", "created_at" => Time.new, "name" => "sebas_m3"},
            {"text" => "ほげ", "created_at" => Time.new, "name" => "test_user"},
            {"text" => "test #test", "created_at" => Time.new, "name" => "sebas_m3"},
        ]
        timeline = []
        data.each do |d|
            timeline << Tweet.new(d["text"], d["created_at"], d["name"])
        end
        return timeline
    end

    # @ex Twitter.user_timeline("sebas_m3", "count" => 15)
    # @param name [String]
    # @param options [Hash]
    # @return [Array<Tweet>]
    def user_timeline(name, options = {})
        data = [
            {"text" => "おはようございます", "created_at" => Time.new, "name" => name},
            {"text" => "おやすみなさい", "created_at" => Time.new, "name" => name},
            {"text" => "どういたしまして", "created_at" => Time.new, "name" => name},
            {"text" => "ごきげんよう", "created_at" => Time.new, "name" => name},
        ]
        timeline = []
        data.each do |d|
            timeline << Tweet.new(d["text"], d["created_at"], d["name"])
        end
        return timeline
    end

    # @ex Twitter.mentions
    # @return [Array<Tweet>]
    def mentions
        data = [
            {"text" => "@#{NAME} おはよう", "created_at" => Time.new, "name" => "sebas_m3"},
            {"text" => "@#{NAME} おやすみ", "created_at" => Time.new, "name" => "sebas_m3"},
            {"text" => "@#{NAME} かわいい", "created_at" => Time.new, "name" => "sebas_m3"},
            {"text" => "@#{NAME} hoge #hoge", "created_at" => Time.new , "name" => "alice"}
        ]
        mention = []
        data.each do |d|
            mention << Tweet.new(d["text"], d["created_at"], d["name"])
        end
        return mention
    end

    # @ex Twitter.user(123).name  #=> "sebas_m3"
    # @param id [Integer]
    def user(id)
        @id = id
        # @return [String]
        def name
            name = "sebas_m3"
            return name
        end
        module_function :name
    end

    # @ex Twitter.follower_ids("sebas_m3").ids
    # @param name [String]
    # @return [Array<Integer>]
    def follower_ids(name)
        @name = name
        def ids
            ids = [123, 345, 234, 567]
            return ids
        end
        module_function :ids
    end

    # @ex Twitter.friend_ids("sebas_m3").ids
    # @param name [String]
    # @return [Array<Integer>]
    def friend_ids(name)
        @name = name
        def ids
            ids = [123, 45, 234, 57]
            return ids
        end
        module_function :ids
    end

    # @ex Twitter.follow(123)
    # @param id [Integer]
    # @return [Boolean]
    def follow(id)
        return true
    end

    # @ex Twitter.unfollow(123)
    # @param id [Integer]
    # @return [Boolean]
    def unfollow(id)
        return true
    end

    module_function :configure, :update, :home_timeline, :user_timeline, :mentions,
                    :user, :follower_ids, :friend_ids, :follow, :unfollow
end


#=================================================
# Tweet クラス
#-------------------------------------------------
# 特にいじる必要はなし
#=================================================
class Tweet
    @@id = 0
    attr_reader :text, :created_at
    def initialize(text, created_at, name = "test_user")
        @text = text
        @created_at = created_at
        @name = name
    end

    # @note user.screen_name の実現
    # @note user.id の実現 (id は10刻み)
    def user
        return self
    end
    def screen_name
        return @name
    end
    def id
        @@id += 10
        return @@id
    end
end


