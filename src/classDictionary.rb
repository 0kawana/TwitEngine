# encoding : utf-8

#===========================================================
# classDictionary.rb
# Dictionaryクラス
# PatternItemクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/05
#===========================================================

require 'mysql'

class Dictionary
    # 初期化
    def initialize(new_time)
        # DBからの読み込み
        mysql = Mysql.new('127.0.0.1', 'gembaf', 'hoge', 'mary_db')

        # ランダム辞書は生まれ変わりました
        # テスト用としてランダム辞書としているが、本来は返信辞書の役割
        @random = {}
        res = mysql.query("SELECT type, phrase FROM random")
        res.each do |type, phrase|
            if @random.has_key?(type)     # typeがすでに存在している場合
                @random[type].add_phrase(phrase)
            else        # 存在していない場合はPatternItemオブジェクトを生成
                # layerとpointの部分にはダミーとしてnil
                @random[type] = PatternItem.new(phrase, nil, nil)
            end
        end
        # puts @random    #デバッグ用

        @regular = []
        File.open(DIR_DATA + "/Regular.csv", 'r') do |f|
            f.each do |line|
                line.chomp!
                next if line.empty?
                @regular.push(line)
            end
        end

        # こいつも生まれ変わりました
        @pattern = {}
        res = mysql.query("SELECT type, phrase, layer, point FROM pattern")
        res.each do |type, phrase, layer, point|
            if @pattern.has_key?(type)     # typeがすでに存在している場合
                @pattern[type].add_phrase(phrase)
            else        # 存在していない場合はPatternItemオブジェクトを生成
                @pattern[type] = PatternItem.new(phrase, layer.to_i, point.to_i)
            end
        end

        # シャッフル
        @regular.shuffle!
    end

    # !現在は使っていない
    def study(input)
        if @regular.include?(input)
            return
        end
        @regular.push(input)
    end

    # !現在は使っていない
    def save
        File.open(DIR_DATA + "/random.txt", 'w') do |f|
            f.puts @regular
        end
    end

    # アクセサの追加
    attr_reader :random, :regular, :pattern
end


# 使い始めた
class PatternItem
    # 初期化
    def initialize(phrase, layer, point)
        @phrases = [phrase]
        @layer = layer
        @point = point
    end

    # phrasesに追加
    def add_phrase(phrase)
        @phrases.push(phrase)
    end

    # アクセサの追加
    attr_reader :phrases, :layer, :point
end


