# encoding : utf-8

# csvファイルからDBに登録するスクリプトです
# mary_dbというDBと、自分のユーザを作っておけばすべて登録できます
# 新しく単語を登録したい時もこれを走らせればいけます
# ユーザ名とパスワードは自分のに変えてください
#
# テーブルを完全に作り替えているので、使うときは要注意!!!!

require 'pg'

dir = File.expand_path(File.dirname(__FILE__))

conn = PGconn.connect('localhost', 5432, '', '', 'mary_db', 'gembaf', 'hoge')

# 応答用辞書
begin
    conn.exec("DROP TABLE response")
    puts "drop table response"
rescue
    puts "table response does not exist"
ensure
    puts "create table"
end

query = <<SQL
CREATE TABLE response (
    no int PRIMARY KEY,
    type text,
    phrase text,
    mood int,
    act_time00_03 boolean,
    act_time03_06 boolean,
    act_time06_09 boolean,
    act_time09_12 boolean,
    act_time12_15 boolean,
    act_time15_18 boolean,
    act_time18_21 boolean,
    act_time21_24 boolean,
    exist boolean
)
SQL
conn.exec(query)

conn.exec("COPY response FROM '#{dir}/response.csv' WITH CSV")

# パターン辞書
begin
    conn.exec("DROP TABLE pattern")
    puts "drop table pattern"
rescue
    puts "table pattern does not exist"
ensure
    puts "create table"
end

query = <<SQL
CREATE TABLE pattern (
    no int PRIMARY KEY,
    type text,
    phrase text,
    layer int,
    mood int,
    exist boolean
)
SQL
conn.exec(query)

conn.exec("COPY pattern FROM '#{dir}/pattern.csv' WITH CSV")

# 定期用辞書
begin
    conn.exec("DROP TABLE regular")
    puts "drop table regular"
rescue
    puts "table regular does not exist"
ensure
    puts "create table"
end

query = <<SQL
CREATE TABLE regular (
    no int PRIMARY KEY,
    phrase text,
    hour int,
    exist boolean
)
SQL
conn.exec(query)

conn.exec("COPY regular FROM '#{dir}/regular.csv' WITH CSV")


