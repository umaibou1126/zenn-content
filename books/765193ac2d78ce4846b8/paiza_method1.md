---
title: "【Ruby】paizaで頻出メソッドまとめてみた"
---

# ◆ eachメソッド + 配列

```
//サンプル用の配列作成
sample = [1,2,3,4]

//出力結果を格納する配列を作成
result = []

//オブジェクト：sample配列　
sample.each do |i|

//変数t：sample配列から変数tに格納される
if i == 1

//上記で作成した配列に格納する
 result.push(i)
end
```

# ◆ 入力値の受け取り方4選

```
//入力値が１行の場合　
input = gets.split.map(&:to_i)

//入力値を一括で配列格納
input = readlines.map &:to_i

//変数宣言 + 配列①
a,b,c = gets.split(" ").map &:to_i

//変数宣言 + 配列②　改行なし
a,b,c = gets.chomp.split(" ").map &:to_i

//入力値を改行なしで配列格納
input = readlines(chomp: true).map(&:to_s)
```

# ◆ include? / blankメソッド

 - **include?メソッド**：配列に``特定の値が存在するか``判定
 - **blank?メソッド**：``配列の中身が存在するか``判定

```
sample = ["a","b","c"]

//include?メソッド
if.sample.include?("a")
  puts "true"
end

//blank?メソッド
if.sample.blank?
  puts "true"
end

//include?メソッド + 変数
sample_num = 3

if.sample.include?("#{sample_num}")
  puts "true"
end
```

# ◆ each_consメソッド

```
//sample配列作成
sample = [1,2,3,4,5]

//each_consメソッドで分割
result = sample.each_cons(2).to_a

//eachメソッドで計算
result.each do |t|
   puts result[1] - result[0]
end
```

# 参考文献

 - [Ruby　標準入力から値を受け取る方法](https://qiita.com/Hayate_0807/items/2e9705091b181a104621)

