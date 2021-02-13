---
title: "EC2 / VPC作成手順"
---

# 基本コマンド



### Terraformインストール
```
$ brew install terraform
```



### AWS CLIのprofile追加
```
$ aws configure --profile XXXXXXX
```



### 秘密鍵・公開鍵作成
```
$ ssh-keygen -t rsa -f XXXXXXX -N ''
```



### SSH接続
```
$ ssh -i 秘密鍵 ec2-user@IPアドレス
```














# AWS環境設定ファイル(*.tf)作成
```provider.tf
provider "aws" {

  profile = "XXXXXXX"  #AWS CLIのprofile名
  region  = "ap-northeast-1"

}
```

##### terraform.tfvarsを用いた設定方法 ▼
- [お金をかけずに、TerraformでAWSのVPC環境を準備する](https://qiita.com/CkReal/items/1dbbc78888e157a80668)






# EC2定義ファイル作成
▼下記参照
[TerraformでVPC・EC2インスタンスを構築してssh接続する](https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5)

```ec2.tf
# ====================
#
# AMI
#
# ====================
# 最新版のAmazonLinux2のAMI情報
data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ====================
#
# EC2 Instance
#
# ====================
resource "aws_instance" "example" {
  ami                    = data.aws_ami.example.image_id
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id              = aws_subnet.example.id
  key_name               = aws_key_pair.example.id
  instance_type          = "t2.micro"

  tags = {
    Name = "example"
  }
}

# ====================
#
# Elastic IP
#
# ====================
resource "aws_eip" "example" {
  instance = aws_instance.example.id
  vpc      = true
}

# ====================
#
# Key Pair
#
# ====================
resource "aws_key_pair" "example" {
  key_name   = "example"
  public_key = file("./example.pub") # `ssh-keygen`コマンドで作成した公開鍵を指定
}
```







# VPC定義ファイル作成
▼下記参照
[TerraformでVPC・EC2インスタンスを構築してssh接続する](https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5)

```vpc.tf
# ====================
#
# VPC
#
# ====================
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # DNS解決を有効化
  enable_dns_hostnames = true # DNSホスト名を有効化

  tags = {
    Name = "example"
  }
}

# ====================
#
# Subnet
#
# ====================
resource "aws_subnet" "example" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.example.id

  # trueにするとインスタンスにパブリックIPアドレスを自動的に割り当ててくれる
  map_public_ip_on_launch = true

  tags = {
    Name = "example"
  }
}

# ====================
#
# Internet Gateway
#
# ====================
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example"
  }
}

# ====================
#
# Route Table
#
# ====================
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example"
  }
}

resource "aws_route" "example" {
  gateway_id             = aws_internet_gateway.example.id
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

# ====================
#
# Security Group
#
# ====================
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id
  name   = "example"

  tags = {
    Name = "example"
  }
}

# インバウンドルール(ssh接続用)
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.example.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# インバウンドルール(pingコマンド用)
resource "aws_security_group_rule" "in_icmp" {
  security_group_id = aws_security_group.example.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
}

# アウトバウンドルール(全開放)
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.example.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}
```


# Elastic IP出力定義
▼下記参照
[TerraformでVPC・EC2インスタンスを構築してssh接続する](https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5)

```terraform.output.tf
# ====================
#
# Output
#
# ====================
# apply後にElastic IPのパブリックIPを出力する
output "public_ip" {
  value = aws_eip.example.public_ip
}
```








# リソース作成





### プラグイン初期化
```
$ terraform init
```




### 構文・パラメータチェック
```
$ terrafrom plan
```




### AWSコンソール実行
```
$ terrafrom apply
```




### 現在の状況確認
```
$ terraform show
```




### 削除
```
$ terrafrom destroy
```

# 参考文献

- [TerraformでVPC・EC2インスタンスを構築してssh接続する](https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5)
- [Terraformでawsのec2インスタンスを立ち上げる](https://qiita.com/bunty/items/5ceed66d334db0ff99e8)
- [AWS CLI の profile を追加する](https://qiita.com/itooww/items/bdc2dc15213da43a10a7)
- [お金をかけずに、TerraformでAWSのVPC環境を準備する](https://qiita.com/CkReal/items/1dbbc78888e157a80668)
