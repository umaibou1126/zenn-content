---
title: "つまづいた用語一覧③"
---


# 背景
`最も本試験の難易度に近い`と言われている[【SAA-C02版】AWS 認定ソリューションアーキテクト アソシエイト模擬試験問題集（6回分390問）](https://www.udemy.com/course/aws-knan/)の中で、<br>自分が解いていてつまづいた箇所をピックアップしました。


# ◆ つまづいた用語一覧

|用語 |意味 |
|:-----|:--------|
|NATインスタンス|プライベートサブネットのインターネットアクセスを許可。<br>**送信元/送信先チェックの無効化**
|**NATゲートウェイ**|目的はNATインスタンスと同じ。**Elastic IPアドレスの割り当て**が必須|
|ブロードキャストアドレス|**同じネットワークにいる全ノード**に対して同じデータを散布する|
|**マルチキャスト**|複数のノードに対して**同じパケット(データ)**を送付する|
|ハイパーバイザー|VMWare, Hyper-Vなどの**仮想マシンソフト**|
|インスタンスストアボリューム|インスタンスが**終了・停止**した際に削除される|
|instance-Store-Backed|起動ディスクが**インスタンスストア**|
|**プロキシ**|**内部NWからインターネット接続**を行う際の中継サーバ|
|**ユーザデータ**|**EC2インスタンスの初回起動時**に実行したい処理を設定する<br>※ElasticIPアドレスの紐付けなど|
|メタデータ|**インスタンスID**や**IPアドレス**などEC2インスタンス自身に関するデータ|
|**DHCP**(Dynamic Host Configuration Protocol)|クライアントサーバ方式で、DHCPサーバが**NWアドレスを動的に割り当て**、<br>設定情報と共に、ホストに送信する|
|クライアントサーバシステム|**サーバ/クライアント**に分け、役割分担する|
|トランザクション|**複数の処理を１つ**にまとめたもの|
|**OLTP**(Online Transaction Processing)|**トランザクション処理**を行う**データベース**|
|**OLAP**(Online Analytical Processing)|**分析処理**を行う**データベース**|
|リスナー|**接続リクエストをチェック**するプロセスのこと|
|ALB パスベースルーティング|・明らかな**不正アクセスを上位レイヤーで弾く**役割<br>・任意のアクセスパスを**ターゲットグループに登録**する<br>・**対象リスナー**(https)などの設定|
|**クラスタープレイスメントグループ**|**単一AZ内のインスタンス**を論理的にグループ化<br>**低レイテンシーのネットワーク**に参加する<br>Linuxの**拡張ネットワーキング**合わせて使用される|
|**カスタマーゲートウェイ**|**VPN接続**の際の**作業者側**のアンカー|
|**仮想プライベートゲートウェイ**|**VPN接続**の際の**AWS側**のアンカー|
|**MD5チェックサム**|**S3にアップロード**された**オブジェクトの整合性**を確認する<br>AWS CLIで**整合性**を確認する<br>**MD5チェックサム値**を**HTTPヘッダー**に格納する|
|CIDRブロック|IPアドレスの**ネットワーク部** / **ホスト部**で決められた**ブロック単位**で区切るのが普通<br>**CIDR**は任意の**ブロック単位**で区切ることが出来る|
|**シャーディング**|データを**複数ノードに分割**<br>**リクエスト分散** / **スループット向上**|
|スループット|単位時間あたりに処理できる量のこと|
|**マスター/スレーブ**|**1つが管理** / **残りが制御**という役割方式|
|sequential|シーケンシャル順次的な / 連続的な|
|**スポットブロック**|**スポットインスタンス**を1〜６時間継続して利用できるようになった機能|
|**スポットフリート**|自動で**最安値のインスタンス**を選択して起動する|
|AWS STS|**アクセスキー**/**シークレットキー**/**セッショントークン**の３つが発行される|
|RDS/DBスナップショット|**DBスナップショット**を取得するためには新しいインスタンスの起動が必要<br>RDSのスケールアップには**停止**が必要|
|ECU(EC2 Compute Unit)|EC2インスタンスの**スペック単位**|
|**Source IP**|**IAMロール**を使用して、特定のIPアドレスからAPI呼び出しを**制限**する|
|WAF(web application Firewall)|**IDS**/**IPS**で防ぐことのできない不正な攻撃からwebアプリケーションを防御する**ファイアーウォール**のこと|
|**eth0**|仮想サーバのNICが**インターネット通信全開**であること|
|インターフェース|機器に関する**外部との接続部分**の総称|
|VPC/サブネットのCIDR範囲|デフォルトVPCのCIDRは172.31.0.0/**16**、<br>デフォルトサブネットはCIDRのうち/**20** CIDRを使用|
|**S3 export/import**|大量の**物理ストレージデバイス**からAWSに転送するのに使用するサービス|
|フェデレーション STS|認証の際に**STS**を使用することでセキュリティが保持される|
|**パッチ**|母体のプログラムに追加することで**プログラムの変更/機能追加**を促せること|
|バッチ|複数の処理を　一括で行えるようにする方法|
|**ラウンドロビン方式**|**ロードバランサー**による**サーバ**/**リクエスト**振り分け方式の一つ|
|**IOPS**(Input OutPut Per Second)|**１秒あたり**に処理出来る**アクセス数**  ※**HDDは低い** / SSDは高い|
|IOPSとスループット|1秒あたりの**最大データ送信料**　※スコープ(範囲)は広い ※**bps** /**kbps**など|