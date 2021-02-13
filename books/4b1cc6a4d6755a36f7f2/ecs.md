---
title: "ECS / IAM作成手順"
---

# Terraformインストール手順

#### ◆ 最新バージョンの確認　
- https://releases.hashicorp.com/terraform/

#### ◆ インストールコマンド
```
$ sudo yum install wget unzip
$ wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
$ sudo unzip ./terraform_0.12.25_linux_amd64.zip -d /usr/local/bin/
$ terraform -v
```

#### ◆ tfenvを利用したバージョン管理

- tfenv：Terraformのバージョン管理に特化したツール

```
//git clone 〜 パス設定
$ git clone https://github.com/tfutils/tfenv.git ~/.tfenv
$ echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
$ source ~/.bash_profile

//tfenvインストール
$ tfenv install latest
$ tfenv use latest
$ tfenv list
```

# terraform用語

|用語      |意味     |
|:--------|:---------------------------------------|
|State|Terraformで管理するリソースの状態。.tfstateのこと|
|tf.state|ローカルにtfstateファイルが生成されるが、S3で管理するのが基本|
|Backend|Stateの保存先。   ※S3など|
|Resource|Terraformで管理する対象の基本単位|
|Module|Resourceを再利用するためにまとめたTerraformのコード|

# 初期設定

#### ◆ terraform.tfvars定義
```
$ cat >> ./terraform.tfvars  << FIN
access_key = "*****************"
secret_key = "*****************"
db_user = "XXXXX"
db_pass = "XXXXXXXXX"
FIN
```

#### ◆ terraform workspace作成
```
$ terraform workspace new development
$ terraform workspace select development
```

#### ◆ S3用のprofile作成   ※tfstate格納用
```
$ aws configure --profile s3-profile
```

# main.tf
- [AWS FargateとTerraformで最強＆簡単なインフラ環境を目指す](https://qiita.com/tarumzu/items/2d7ed918f230fea957e8)

```main.tf
// 変数を定義　※terraform.tfvars参照
variable "access_key" {}
variable "secret_key" {}
variable "token" {}
variable "db_user" {}
variable "db_pass" {}
variable "region" { default = "ap-northeast-1"}

// S3にtfstateを格納
terraform {
  backend "s3" {
    bucket = "sample-project"
    key    = "sample-project.terraform.tfstate"
    region     = "ap-northeast-1"
    profile = "sample-profile"
  }
}

// プロバイダ設定  ※上記変数参照
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

// modulesのソースを指定
module "base" {
  region                            = "${var.region}"
  db_user                           = "${var.db_user}"
  db_pass                           = "${var.db_pass}"
  source = "./modules"
}
```

# ecs.tf
```ecs.tf
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "sample-cluster"
}
```

# IAM Policy / IAM Role作成

- [Terraform](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html)

```iam.tf
data "aws_iam_policy_document" "samplepolicy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::foo-bucket/*",
    ]
  }
}

resource "aws_iam_policy" "samplepolicy" {
  name        = "samplepolicy"
  path        = "/"
  description = ""
  policy      = data.aws_iam_policy_document.samplepolicy.json
}

data "aws_iam_policy_document" "samplerole_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "samplerole" {
  name               = "samplerole"
  assume_role_policy = data.aws_iam_policy_document.samplerole_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "samplerole_attachement" {
  role       = aws_iam_role.samplerole.name
  policy_arn = aws_iam_policy.samplepolicy.arn
}
```

# 参考文献
- [Terraform - CentOS 7 に Terraform をインストールして AWS へ接続](https://qiita.com/anfangd/items/5eac63d77264e796ffb5)
- [Terraformインストール](https://qiita.com/moroishisan/items/35736e9a0332d0df9206)
- [AWS FargateとTerraformで最強＆簡単なインフラ環境を目指す](https://qiita.com/tarumzu/items/2d7ed918f230fea957e8)
- [tfenvでTerraformのバージョン管理をする](https://qiita.com/kamatama_41/items/ba59a070d8389aab7694)
- [Terraform Workspacesの基礎と使い方について考えてみた！](https://dev.classmethod.jp/articles/how-to-use-terraform-workspace/)
- [Amazon ECS+Fargate まとめ (terraformを使ったクラスタ構築とオートスケール、ブルーグリーンデプロイ)](https://qiita.com/marnie_ms4/items/202deb8f587233a17cca)
- [Terraform職人入門: 日々の運用で学んだ知見を淡々とまとめる](https://qiita.com/minamijoyo/items/1f57c62bed781ab8f4d7)
- [TerraformでJSONにコメントを書きたいだけの人生だった](https://qiita.com/minamijoyo/items/18fa28132cf737c86ddf)
