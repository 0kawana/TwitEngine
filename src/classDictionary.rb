# encoding : utf-8

#===========================================================
# classDictionary.rb
# Dictionaryクラス
# PatternItemクラス
#-----------------------------------------------------------
# Author : gembaf
# 2013/02/05
#===========================================================

class Dictionary
    # 初期化
    def initialize
        @random = []
        File.open(DIR_DATA + "/random.txt", 'r') do |f|
            f.each do |line|
                line.chomp!
                next if line.empty?
                @random.push(line)
            end
        end

        @regular = []
        File.open(DIR_DATA + "/Regular.csv", 'r') do |f|
            f.each do |line|
                line.chomp!
                next if line.empty?
                @regular.push(line)
            end
        end

        # !現在は使っていない
        @pattern = []
        File.open(DIR_DATA + "/pattern.txt", 'r') do |f|
            f.each do |line|
                pattern, phrases = line.chomp.split(",")
                next if pattern.nil? or phrases.nil?
                @pattern.push(PatternItem.new(pattern, phrases))
            end
        end

        # シャッフル
        @random.shuffle!
        @regular.shuffle!
        @pattern.shuffle!
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


# !現在は使っていない
# 参考にした本では、テキストから全てを読み込んでいたので複雑になっている
# DBを使うのならばおそらくほとんど必要ない
class PatternItem
    SEPARATOR = /^((-?\d+)##)?(.*)$/

    def initialize(pattern, phrases)
        SEPARATOR =~ pattern
        @modify, @pattern = $2.to_i, $3

        @phrases = []
        phrases.split("|").each do |phrase|
            SEPARATOR =~ phrase
            @phrases.push({"need"=>$2.to_i, "phrase"=>$3})
        end
    end

    def match(str)
        return str.match(@pattern)
    end

    def choice(mood)
        choices = []
        @phrases.each do |p|
            if suitable?(p["need"], mood)
                choices.push(p["phrase"])
            end
        end
        return (choices.empty?) ? nil : select_random(choices)
    end

    def suitable?(need, mood)
        return true if need == 0
        if need > 0
            return mood > need
        else
            return mood < need
        end
    end

    attr_reader :modify, :pattern, :phrases
end


