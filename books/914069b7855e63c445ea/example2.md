---
title: "Blockchain 頻出用語"
---

# P2PKH / P2SH
 - PSPKH：``公開鍵``のハッシュ
 - P2SH：``スクリプト``のハッシュ

# Base58 / Base64
 - Base58：Base64から``紛らわしい6文字``を除いたもの
 - Base58Check：``無効なビットコインアドレス``を検出

# RIPEMD-160
 - ``SHA256 + RIPEMD-160``の組み合わせで使われる
 - OP_HASH160 = ``RIPEMD160(SHA256(data))``

# ビックエンディアン / リトルエンディアン
 - ビックエンディアン：``最初``のバイトからデータを並べる（そのまま）
 - リトルエンディアン：``最後``のバイトからデータを並べる（逆）

# BIP
 - ``Bitcoin Improvement Proposals``の略
 - ビットコイン技術の発展のためのに作成、公開される``草案群``

# BIP32
 - ``階層的決定性``ウォレット
 - ``128bits``エントロピー
 - ``HMAC-SHA512``


# 参考文献
 - [P2PK[H] (Pay to Public Key [Hash])](https://programmingblockchain.gitbook.io/programmingblockchain-japanese/other_types_of_ownership/p2pk-h-_pay_to_public_key_-hash)
 - [P2PK、P2PKH、P2SH、P2WPKHとは-ELI5](https://bitcoin.stackexchange.com/questions/64733/what-is-p2pk-p2pkh-p2sh-p2wpkh-eli5)
 - [アドレスや秘密鍵の見間違えを防ぐ特徴的なフォーマットBase58](https://bitcoin.stackexchange.com/questions/64733/what-is-p2pk-p2pkh-p2sh-p2wpkh-eli5)
 - [​Base58とは？仮想通貨のアドレス、公開鍵、秘密鍵などを作成する技術を簡単に説明します！](https://coinotaku.com/posts/18451)
 - [用語集](https://bitflyer.com/en-eu/glossary/ripemd160)
 - [How to compute OP_HASH160 of public key](https://gist.github.com/t4sk/0740f224a70d9eae9564c3d856039264)
 - [[バイトオーダー]ビックエンディアン/リトルエンディアン](https://qiita.com/ryuichi1208/items/31442f9e8a7a7c94aeec)
 - [BIP32でマスターキーを生成するために必要なHMAC-SHA256のラウンド数](https://bitcoin.stackexchange.com/questions/83807/how-many-rounds-of-hmac-sha256-needed-to-generate-the-master-key-in-bip32)
 - [ビットコイン（Bitcoin）用語集](https://bitflyer.com/ja-jp/glossary/bip)
 - [暗号資産（仮想通貨）用語集](https://bitbank.cc/glossary/bip0032)
 - [【ビットコイン】ウォレットの概要とHDウォレットの仕組み](https://blockchain.gunosy.io/entry/2017/12/21/165314)
