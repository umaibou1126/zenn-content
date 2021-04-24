#!/usr/bin/env bash

set -euo pipefail

function main() {
    docker-compose run web python3 manage.py migrate --fake twitter_analyzer zero
    docker-compose run web python3 manage.py showmigrations
    docker-compose run web python3 manage.py showmigrations
    docker-compose run web python3 manage.py createsuperuser

    # MySQL
    # show columns from twitter_analyzer_tweetsdata
    # delete from twitter_analyzer_tweetsdata where id = 1
    # insert into twitter_analyzer_tweetsdata values (1, 200);

    # Git
    git merge --abort ##ブランチ切り替え失敗時
    git rm -r --cached .
    gh repo create CloudFormation_YAML
}

main
