# encoding : utf-8

# csvファイルからDBに登録するスクリプトです
# mary_dbというDBと、自分のユーザを作っておけばすべて登録できます
# 新しく単語を登録したい時もこれを走らせればいけます
# ユーザ名とパスワードは自分のに変えてください
#
# テーブルを完全に作り替えているので、使うときは要注意!!!!

require 'mysql'

mysql = Mysql.new('127.0.0.1', 'gembaf', 'hoge', 'mary_db')

# ランダム辞書
begin
    mysql.query("DROP TABLE random")
    puts "drop table random"
rescue
    puts "table random is not exist"
else
    puts "create table"
end

# 今後、時間帯フラグと必要機嫌値を追加予定
sql = <<SQL
CREATE TABLE random (
    no int NOT NULL PRIMARY KEY,
    type text,
    phrase text
)
SQL
mysql.query(sql)

sql = <<SQL
LOAD DATA INFILE '/home/gembaf/TwitEngine/data/random.csv'
INTO TABLE random
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
SQL
mysql.query(sql)


# パターン辞書
begin
    mysql.query("DROP TABLE pattern")
    puts "drop table pattern"
rescue
    puts "table pattern is not exist"
else
    puts "create table"
end

sql = <<SQL
CREATE TABLE pattern (
    no int NOT NULL PRIMARY KEY,
    type text,
    phrase text,
    layer int,
    point int
)
SQL
mysql.query(sql)

sql = <<SQL
LOAD DATA INFILE '/home/gembaf/TwitEngine/data/pattern.csv'
INTO TABLE pattern
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
SQL
mysql.query(sql)


