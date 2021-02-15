---
title: "ECS自動デプロイ - Terraform編 -"
---

## ツリー図
```
.
├── acm.tf
├── alb.tf
├── backend.tf
├── ecs.tf
├── files
│   └── task-definitions
│       └── container.json
├── rds.tf
├── security_group.tf
├── terraform.tfvars
├── variables.tf
├── vpc.tf
├── vpc_gateway.tf
├── vpc_routetable.tf
└── vpc_subnet.tf
```

## Terraform / AWS CLIコマンド

##### ◆ AWS CLIコマンド
```
/// ECS
$ aws ecs list-task-definitions --region ap-northeast-1
$ aws ecs list-clusters
$ aws ecs register-task-definition --family sample-service  --cli-input-json file://container.json

/// RDS
$ mysql -h sample-rds.XXXXXX.XXXXXX.rds.amazonaws.com -P 3306 -u XXXX -p
```

##### ◆ EC2インストール
```
$ sudo yum install git
$ yum list installed | grep mariadb
$ sudo yum remove mariadb-libs
$ sudo yum-config-manager --disable mysql57-community
$ sudo yum-config-manager --enable mysql80-community
$ sudo yum install -y mysql-community-client
$ mysql --version
```



## 各tfファイル

##### ◆ ecs.tf

```ecs.tf
# ====================
# Cluster
# ====================
resource "aws_ecs_cluster" "sample-cluster" {
  name = "sample-cluster"
}

# ====================
# CloudWatch logs
# ====================
resource "aws_cloudwatch_log_group" "sample-log-group" {
  name = "sample-log-group"
  tags = {}
}

# ====================
# task_definition
# ====================
resource "aws_ecs_task_definition" "sample-task-definition" {
  //family：複数のタスク定義をまとめる際に使用
  family                   = "sample-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = file("files/task-definitions/container.json")
}

# ====================
# Service
# ====================
resource "aws_ecs_service" "sample-service" {
  cluster                            = aws_ecs_cluster.sample-cluster.id
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  name                               = "sample-service"
  task_definition                    = aws_ecs_task_definition.sample-task-definition.arn
  //desired_count：タスク数
  desired_count = 1

  /// autoscalingで動的に変化する値を無視する ///
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.sample-target-group.arn
    container_name   = "sample-container"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.sample-subnet-1.id, aws_subnet.sample-subnet-2.id]
    security_groups  = [aws_security_group.sample-security-group-app.id, aws_security_group.sample-security-group-rds.id]
    assign_public_ip = "true"
  }
}
```

##### ◆ container.json

```files/container.json
[
    {
        "image": "XXXXXX.dkr.ecr.XXXXXX.amazonaws.com/sample_dev:latest",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "sample-log-group",
                "awslogs-region": "ap-northeast-1",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "cpu": 512,
        "memory": 1024,
        "mountPoints": [],
        "environment": [],
        "networkMode": "awsvpc",
        "name": "sample-container",
        "essential": true,
        "portMappings": [
            {
                "hostPort": 80,
                "containerPort": 80,
                "protocol": "tcp"
            }
        ],
        "command": [
            "/usr/bin/supervisord"
        ]
    }
]
```

##### ◆ alb.tf
```alb.tf
# ====================
# ALB
# ====================
resource "aws_alb" "sample-alb" {
  name                       = "sample-alb"
  security_groups            = [aws_security_group.sample-security-group-alb.id]
  subnets                    = [aws_subnet.sample-subnet-1.id, aws_subnet.sample-subnet-2.id]
  internal                   = false
  enable_deletion_protection = false
}

# ====================
# Target Group
# ====================
resource "aws_alb_target_group" "sample-target-group" {
  name        = "sample-target-group"
  depends_on  = [aws_alb.sample-alb]
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.sample-vpc.id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/ping"
    port                = 80
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 10
    matcher             = 200
  }
}

# ====================
# ALB Listener HTTP
# ====================
resource "aws_alb_listener" "sample-alb-http" {
  load_balancer_arn = aws_alb.sample-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.sample-target-group.arn
    type             = "forward"
  }
}

# ====================
# ALB Listener HTTPS
# ====================
resource "aws_alb_listener" "sample-alb-https" {
  load_balancer_arn = aws_alb.sample-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = aws_acm_certificate.sample-acm.arn

  default_action {
    target_group_arn = aws_alb_target_group.sample-target-group.arn
    type             = "forward"
  }
}

# ====================
# listener_rule
# ====================
resource "aws_alb_listener_rule" "sample-listener-rule" {
  depends_on   = [aws_alb_target_group.sample-target-group]
  listener_arn = aws_alb_listener.sample-alb-http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.sample-target-group.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
```

##### ◆ acm.tf
```acm.tf
# ====================
# ACM
# ====================
resource "aws_acm_certificate" "sample-acm" {
  domain_name               = "sample.com"
  subject_alternative_names = ["*.sample.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
```

##### ◆ rds.tf
```rds.tf
# ====================
# db_subnet_group
# ====================
resource "aws_db_subnet_group" "sample-rds-subnet-group" {
  name        = "sample-rds-subnet-group"
  description = "sample-rds-subnet-group"
  subnet_ids  = [aws_subnet.sample-subnet-1.id, aws_subnet.sample-subnet-2.id]
}

# ====================
# db_instance
# ====================
resource "aws_db_instance" "sample-rds" {
  identifier             = "sample-rds"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "test"
  password               = "XXXXXX"
  parameter_group_name   = "default.mysql5.7"
  port                   = "3306"
  vpc_security_group_ids = [aws_security_group.sample-security-group-rds.id]
  db_subnet_group_name   = "${aws_db_subnet_group.sample-rds-subnet-group.name}"
  skip_final_snapshot    = true
}
```

##### ◆ security_group.tf
```security_group.tf
# ====================
# Security Group (app)
# ====================
resource "aws_security_group" "sample-security-group-app" {
  vpc_id = aws_vpc.sample-vpc.id
  name   = "sample-security-group-app"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["X.X.X.X/16"]
    security_groups = [aws_security_group.sample-security-group-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sample-security-group-app"
  }
}



# ====================
# Security Group（ALB）
# ====================
resource "aws_security_group" "sample-security-group-alb" {
  name        = "sample-security-group-alb"
  description = "sample-security-group-alb"
  vpc_id      = aws_vpc.sample-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sample-security-group-alb"
  }
}

# ====================
# Security Group (RDS)
# ====================
resource "aws_security_group" "sample-security-group-rds" {
  name        = "sample-security-group-rds"
  description = "sample-security-group-rds"
  vpc_id      = aws_vpc.sample-vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sample-security-group-app.id]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["X.X.X.X/16"]
    description = "sample-security-group-rds"
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["X.X.X.X/28"]
    description = "sample-security-group-rds"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sample-security-group-rds"
  }
}
```

##### ◆ vpc.tf
```vpc.tf
# ====================
# VPC
# ====================
resource "aws_vpc" "sample-vpc" {
  cidr_block = "X.X.X.X/16"

  tags = {
    Name = "sample-vpc"
  }
}
```

###### ◆ vpc_subnet.tf
```vpc_subnet.tf
# ====================
# Subnet
# ====================
resource "aws_subnet" "sample-subnet-1" {
  cidr_block        = "X.X.X.X/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-subnet-1"
  }
}

resource "aws_subnet" "sample-subnet-2" {
  cidr_block        = "X.X.X.X/24"
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-subnet-2"
  }
}
```

##### ◆ vpc_routetable.tf
```vpc_routetable.tf
# ====================
# Subnet
# ====================
resource "aws_subnet" "sample-subnet-1" {
  cidr_block        = "X.X.X.X/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-subnet-1"
  }
}

resource "aws_subnet" "sample-subnet-2" {
  cidr_block        = "X.X.X.X/24"
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-subnet-2"
  }
}
```

##### ◆ vpc_gateway.tf
```vpc_gateway.tf
# ====================
# Internet Gateway
# ====================
resource "aws_internet_gateway" "sample-gateway" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-gateway"
  }
}
```

##### ◆ variables.tf
```variables.tf
/// tfファイルで使用する変数定義 ///
/// 変数の中身はterraform.tfvarsに記載 ///

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

variable "aws_account_id" {}
```

##### ◆ backend.tf
```backend.tf
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
  profile    = "s3-profile"
}

terraform {
  backend "s3" {
    bucket                  = "sample-s3-file"
    key                     = "terraform.tfstate"
    region                  = "ap-northeast-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "s3-profile"
  }
}
```

## 参考文献
 - [[Terraform][Backends][v0.9]tfstateファイルの管理方法](https://blog.adachin.me/archives/5884)
 - [グループ会社のインフラをECS/Fargateに移行して振り返る](https://engineer.blog.lancers.jp/2020/05/ecs-fargate-replace/)
 - [[AWS][Terraform][Fargate]ECSでコンテナをALB配下に置く](https://blog.adachin.me/archives/11211)
 - [circleci/aws-ecs@1.4.0](https://circleci.com/developer/orbs/orb/circleci/aws-ecs)
 - [AWS ECR/ECS へのデプロイ](https://circleci.com/docs/ja/2.0/ecs-ecr/#docker-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%82%92%E3%83%93%E3%83%AB%E3%83%89%E3%81%97%E3%81%A6-aws-ecr-%E3%81%AB%E3%83%97%E3%83%83%E3%82%B7%E3%83%A5%E3%81%99%E3%82%8B)
