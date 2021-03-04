---
title: "gethコマンド まとめ"
---

## Gethインストール
```
$ brew tap ethereum/ethereum
$ brew install ethereum
```

## Geth起動
```
$ mkdir ~/main_data
$ cd ~/main_data
$ geth --dev --datadir .              // gethプロセス起動
$ geth attach geth.ipc
```

## アカウント作成
```
> eth.accounts                       // アカウント確認
> personal.newAccount("test01")      // アカウント作成
> eth.coinbase                       // etherbase (coinbase)作成
```

## マイニング
```
> miner.start()                     // マイニング開始
> eth.mining                        // マイニング中か否か
> eth.hashrate                      // マイニング中でない場合、ハッシュ・レートは0となる。
> miner.stop()                      // マイニング終了
> eth.getBalance(eth.accounts[0])   // 持ち高表示
```

## 送金
```
> personal.unlockAccount(eth.accounts[0])  // アカウントロック解除
> eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: 10000})
> eth.getBalance(eth.accounts[1])          // 確認
> eth.getTransaction('10x010x010x010x0')   // 手数料（gasPrice）確認
```

## 接続確認
```
> net.listening           // 疎通確認
> net.peerCount           // 接続されているノード数
> admin.nodeInfo
> admin.peers             // 接続されているノード情報
```

## privateネットワーク
```
$ mkdir ~/private_net
$ cd ~/private_net
$ vim Genesis.json        // Genesisファイル作成
$ geth --datadir private_net init Genesis.json
$ geth --dev --datadir .              // gethプロセス起動
$ geth attach geth.ipc
```

# 参考文献
 - [Ethereum スマートコントラクト入門：geth のインストールから Hello World まで](https://qiita.com/amachino/items/b59ec8e46863ce2ebd4a)
 - [Ethereum入門](https://book.ethereum-jp.net/)
 - [net.peerCount 0](https://github.com/ethereum/go-ethereum/issues/16269)
