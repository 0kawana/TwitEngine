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
    # Twitter.user_timeline("sebas_m3", "count" => 15)
    def user_timeline(name, options)
        tweet = [
            {"text" => "hoge", "created_at" => Time.new},
            {"text" => "foo", "created_at" => Time.new},
            {"text" => "メアリ", "created_at" => Time.new},
            {"text" => "てすと", "created_at" => Time.new}
        ]
        return tweet
    end

    # Twitter.user(123).name  #=> "sebas_m3"
    def user(id)
        @id = id
        def name
            name = "sebas_m3"
            return name
        end
        module_function :name
    end

    # Twitter.follower_ids("sebas_m3").ids
    def follower_ids(name)
        @name = name
        def ids
            ids = [123, 345, 234, 567]
            return ids
        end
        module_function :ids
    end

    # Twitter.friend_ids("sebas_m3").ids
    def friend_ids(name)
        @name = name
        def ids
            ids = [123, 45, 234, 57]
            return ids
        end
        module_function :ids
    end

    # Twitter.follow(123)
    def follow(id)
        return true
    end

    # Twitter.unfollow(123)
    def unfollow(id)
        return true
    end

    module_function :user_timeline, :user, :follower_ids, :friend_ids, :follow, :unfollow
end



