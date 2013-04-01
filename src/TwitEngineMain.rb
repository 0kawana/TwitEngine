#!/usr/bin/env ruby
# encoding : utf-8

#===========================================================
# TwitEngineMain.rb
# 本体部分
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/21
#===========================================================

require 'rubygems'
require 'twitter'
require File.expand_path(File.dirname(__FILE__) + '/define')
require File.expand_path(File.dirname(__FILE__) + '/classCharacter')

class Mary
    def initialize
        # configに登録
        Twitter.configure do |config|
            config.consumer_key       = ENV['CONSUMER_KEY']
            config.consumer_secret    = ENV['CONSUMER_SECRET']
            config.oauth_token        = ENV['OAUTH_TOKEN']
            config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
        end
        # 前回実行時の時間の取得・生成
        @old_time = get_oldtime
        # 現在実行時の時間の取得
        #@new_time = Time.new     #=> ローカルではこちら
        @new_time = Time.new + 9*60*60  #=> JSTになるように修正

        # メアリの顕現
        @mary = Character.new(NAME, @new_time)

        # フォロワー同士のリプライには反応しないようにリプライとその他を別に取得
        @timeline = []
        Twitter.mentions.each do |tweet|
            # 前回実行時から今回実行時までの間
            created_at = tweet.created_at + 9*60*60
            if @old_time < created_at and created_at <= @new_time
                @timeline.unshift(tweet)
            else
                # 時間外ならループを抜ける
                break
            end
        end
        Twitter.home_timeline.each do |tweet|
            # 前回実行時から今回実行時までの間
            created_at = tweet.created_at + 9*60*60
            if @old_time < created_at and created_at <= @new_time
                # 自分のツイート以外を先頭に格納
                unless tweet.user.screen_name == NAME or tweet.text.include?("@")
                    @timeline.unshift(tweet)
                end
            else
                # 時間外ならループを抜ける
                break
            end
        end
    end

    def tweet
        # 現在実行時の時間の書き込み
        write_newtime
        # 応答内容とoptionsを決定
        post = @mary.dialogue(@timeline) #=> Hashの配列
        # 呟く
        tweet_post(post)
        # フォロー・フォロワーの整理
        # if @new_time.hour == 4 and (@new_time.min == 0 or @new_time.min == 1 or @new_time.min == 3)
        #if @new_time.hour == 4 and @new_time.min == 0 # 一番人がいなさそうな午前４時で
            @mary.adjust_user
        #end

        html = "Action successful!!<BR>
                #{@old_time.mon}/#{@old_time.day},#{@old_time.hour}:#{@old_time.min}:#{@old_time.sec} ~ #{@new_time.mon}/#{@new_time.day},#{@new_time.hour}:#{@new_time.min}:#{@new_time.sec}"
        return html
    end

    # 前回実行時の時間を取得・生成
    def get_oldtime
        # ファイルが存在しなかった場合
        #return Time.new unless File.exists?("./Runtime.log")   #=> ローカルではこちら
        return Time.new+9*60*60 unless File.exists?("./Runtime.log")

        log = File.read("./Runtime.log")
        # 文字列からTimeオブジェクトを生成
        old_time = Time.gm *log.split(",")
        # タイムゾーンをUTCからJSTに変換
        # 変換によって9時間(9*60*60秒)ずれた分をもとに戻す
        #old_time = old_time.localtime - 9*60*60   #=> ローカルではこちら
        old_time = old_time.localtime
        return old_time
    end

    # 現在実行時の時間の書き込み
    def write_newtime
        File.open("./Runtime.log", 'w') do |file|
            # year,mon,day,hour,min,secの順で書き込み
            file.print @new_time.strftime("%Y,%m,%d,%H,%M,%S")
        end
    end

    # 呟く
    def tweet_post(post)
        post.each do |p|
            begin
                Twitter.update(p["response"], p["options"])
            rescue Timeout::Error, StandardError  # 何らかのエラーがあった場合
                puts "投稿エラー"
            end
        end
    end
end


