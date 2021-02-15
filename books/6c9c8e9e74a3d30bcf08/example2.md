---
title: "ECS自動デプロイ - CircleCI編 -"
---

## CircleCIコマンド

##### ◆ config.ymlチェック
```
$ yamllint .circleci/config.yml
```

##### ◆ CircleCI jobチェック
```
$ circleci orb validate .circleci/config.yml
$ circleci local execute -c .circleci/config.yml --job build
$ circleci build --job rspec .circleci/config.yml
```

## .circleci/config.yml

```:.circleci/config.yml
version: 2.1
orbs:
  aws-ecr: circleci/aws-ecr@6.12.2
  aws-ecs: circleci/aws-ecs@1.3.0


/// executors: ジョブのステップ実行する環境を定義 ///
executors:
  default:
    docker:
      - image: circleci/ruby:2.7.1-node-browsers-legacy
        environment:
          BUNDLE_JOBS: 3
          BUNDLE_RETRY: 3
          BUNDLE_PATH: vendor/bundle
          RAILS_ENV: test
          DATABASE_HOST: '127.0.0.1'
          DB_USERNAME: 'root'
          DB_PASSWORD: 'XXXXXX'
      - image: circleci/mysql:5.7
        environment:
          MYSQL_DATABASE: sample_dev
          MYSQL_USER: 'root'
          MYSQL_ROOT_PASSWORD: 'XXXXXX'
  docker_build:
    machine:
      docker_layer_caching: true


/// commands: ジョブ内で実行する一連のステップをマップとして定義 ///
commands:
  bundle_install_rspec:
    steps:
      - run:
          name: Which bundler?
          command: bundle -v

      /// ジョブのキャッシュを復元することで、ジョブ高速化 ///
      - restore_cache:
          keys:
            - cache-gem-{{ checksum "Gemfile.lock" }}
            - cache-gem-
      - run:
          name: Bundle Install
          command: bundle check || bundle install
      - save_cache:
          key: cache-gem-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle
      - run:
          name: Database create
          command: DISABLE_SPRING=true bin/rake db:create --trace
      - run:
          name: Database setup
          command: DISABLE_SPRING=true bin/rake db:schema:load --trace
      - run:
          name: Run rspec
          command: |
            TZ=Asia/Tokyo \
              bundle exec rspec --profile 10 \
                                --out test_results/rspec.xml \
                                --format progress \
                                $(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)


  /// Vueインストール ///
  vue-installation:
    steps:
      - restore_cache:
          keys:
            - cache-yarn-{{ checksum "yarn.lock" }}
            - cache-yarn-

      - run:
          name: Yarn Install
          command: yarn install

      - save_cache:
          key: cache-yarn-{{ checksum "yarn.lock" }}
          paths:
            - node_modules


/// jobs：実行処理 ///
jobs:
  rspec:
    working_directory: ~/rspec
    executor: default
    steps:
      - checkout
      - bundle_install_rspec
      - vue-installation

  deploy_app:
    working_directory: ~/app
    executor: default
    steps:
      - setup_remote_docker
      - checkout



/// workflows：全てのジョブのオーケストレーション ///
workflows:
  version: 2
  build-and-deploy:
    jobs:
      - rspec
      - deploy_app:
          requires:
            - rspec
      - aws-ecr/build-and-push-image:
          requires:
            - deploy_app
          account-url: AWS_ECR_ACCOUNT_URL
          aws-access-key-id: AWS_ACCESS_KEY_ID
          aws-secret-access-key: AWS_SECRET_ACCESS_KEY
          region: AWS_DEFAULT_REGION
          repo: "${AWS_RESOURCE_NAME_PREFIX}"
          dockerfile: docker/dev/app/Dockerfile
          tag: "${CIRCLE_SHA1}"

      - aws-ecs/deploy-service-update:
          requires:
            - aws-ecr/build-and-push-image
          aws-region: AWS_DEFAULT_REGION
          family: "${AWS_RESOURCE_NAME_PREFIX}-service"
          cluster-name: "${AWS_RESOURCE_NAME_PREFIX}-cluster"
          container-image-name-updates: "container=${AWS_RESOURCE_NAME_PREFIX}-container,image-and-tag=${AWS_ECR_ACCOUNT_URL}/${AWS_RESOURCE_NAME_PREFIX}:${CIRCLE_SHA1}"

      - aws-ecs/run-task:
          requires:
            - aws-ecs/deploy-service-update
          cluster: "${AWS_RESOURCE_NAME_PREFIX}-cluster"
          aws-region: AWS_DEFAULT_REGION
          task-definition: "${AWS_RESOURCE_NAME_PREFIX}-task-definition"
          count: 1
          launch-type: FARGATE
          awsvpc: true
          subnet-ids: subnet-XXXXXX,subnet-XXXXXX
          security-group-ids: sg-XXXXXX,sg-XXXXXX
          overrides: "{\\\"containerOverrides\\\":[{\\\"name\\\": \\\"${AWS_RESOURCE_NAME_PREFIX}-container\\\",\\\"command\\\": [\\\"bundle\\\", \\\"exec\\\", \\\"rake\\\", \\\"db:migrate\\\", \\\"RAILS_ENV=test\\\"]}]}"
```

# 参考文献
 - [[Terraform][Backends][v0.9]tfstateファイルの管理方法](https://blog.adachin.me/archives/5884)
 - [グループ会社のインフラをECS/Fargateに移行して振り返る](https://engineer.blog.lancers.jp/2020/05/ecs-fargate-replace/)
 - [[AWS][Terraform][Fargate]ECSでコンテナをALB配下に置く](https://blog.adachin.me/archives/11211)
 - [circleci/aws-ecs@1.4.0](https://circleci.com/developer/orbs/orb/circleci/aws-ecs)
 - [AWS ECR/ECS へのデプロイ](https://circleci.com/docs/ja/2.0/ecs-ecr/#docker-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%82%92%E3%83%93%E3%83%AB%E3%83%89%E3%81%97%E3%81%A6-aws-ecr-%E3%81%AB%E3%83%97%E3%83%83%E3%82%B7%E3%83%A5%E3%81%99%E3%82%8B)
