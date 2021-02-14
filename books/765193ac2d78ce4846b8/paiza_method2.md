---
title: "【Ruby】paizaで頻出メソッドまとめてみた"
---

# 入力メソッド

```
//入力値:文字列　改行：あり
input = gets

//入力値：文字列　改行：なし
input = gets.chomp

//入力値：数値   改行：あり
input = gets.to_i

//入力値：数値　 改行：なし
input = gets.chomp.to_i
```


# 配列メソッド

- [Ruby　標準入力から値を受け取る方法](https://qiita.com/Hayate_0807/items/2e9705091b181a104621)


```
//入力値を配列に格納　※数値　
input = gets.split.map(&:to_i)

//分割して配列に格納
a,b,c = gets.split(" ").map &:to_i

//入力値を順番に格納
a = readlines.map &:to_i


//複数行 && 複数要素の格納  ※文字列
lines = []
while line = gets
    lines << line.chomp.split(' ')
end


//複数行 && 複数要素の格納  ※数値
lines = []
while line = gets
    lines << line.chomp.split(' ').map(&:to_i)
end
```

# timesメソッド + 配列

```
//繰り返し回数
n = 5
//配列の設定
sample = []

//繰り返し回数分、配列に格納
n.times do
  sample.push(gets.chomp.split(" ").map &:to_i)
end
```

# eachメソッド + 配列

```
//入力値取得
sample = readlines.map &:to_i

//変数宣言
n = 5

//eachメソッド
sample.each do |i|
 if n < 10
    n += 1
 else
    puts "sample"
 end
end
```

# その他

```
//絶対値取得
n = 5
sample = n.abs


//単数形→複数形
sample = "post".pluralize
puts sample
```

# 参考文献

- [【Ruby】getsとgets.chompの違いは改行にあり！](https://qiita.com/Take-st/items/26f29a6dea622d1e7e8d)
- [【Ruby】getsの使い方](https://qiita.com/aamonaamon9/items/7de49e4881ee07e24248)
- [paiza 開発日誌](https://paiza.hatenablog.com/entry/2019/09/20/%E5%88%9D%E5%BF%83%E8%80%85%E3%81%A7%E3%82%82Ruby%E3%81%A7%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E5%95%8F%E9%A1%8C%E3%82%92%E8%A7%A3%E3%81%91%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB)
- [Railsで簡単に英単語を複数形にする方法](https://qiita.com/narikei/items/023dbf1385e798836ae8)
- [Ruby　標準入力から値を受け取る方法](https://qiita.com/Hayate_0807/items/2e9705091b181a104621)
