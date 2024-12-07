#!/bin/bash

set -eux

cd $(dirname $0)

#########################
### Config for global ###
#########################

# pprotein-agentサービスのインストールと起動
sudo cp ../system-services/pprotein-agent.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable pprotein-agent
sudo systemctl start pprotein-agent

# Gitの初期設定
git config --global user.name "haigyo"
git config --global user.email "haigyo@example.com"
git config --global init.defaultBranch main

# 使用するツールのインストール
sudo apt update
sudo apt install -y gh emacs wget curl unzip

# ghにログイン
gh auth login

#########################
### Config for local ###
#########################

# 例年どおりならたぶんここでしょう
cd /home/isucon/webapp

# gitの初期化
git init
git remote add origin https://github.com/haigyo/isucon14_20241208
git commit --allow-empty -m 'init'

# etcファイルのコピー、Gitに追加
mkdir -p ./etc
sudo cp -RT /etc/nginx ./etc/nginx
sudo cp -RT /etc/mysql ./etc/mysql
sudo chown -R $USER:$USER ./etc
git add ./etc
git commit -m 'add etc files'
git push --set-upstream origin main

# Nginxの設定変更の促し; いつもltsvの設定を探して地味にストレスなので
echo "Nginxの設定を変更してください"
cat << 'EOS'
log_format ltsv "time:$time_local"
                "\thost:$remote_addr"
                "\tforwardedfor:$http_x_forwarded_for"
                "\treq:$request"
                "\tstatus:$status"
                "\tmethod:$request_method"
                "\turi:$request_uri"
                "\tsize:$body_bytes_sent"
                "\treferer:$http_referer"
                "\tua:$http_user_agent"
                "\treqtime:$request_time"
                "\tcache:$upstream_http_x_cache"
                "\truntime:$upstream_http_x_runtime"
                "\tapptime:$upstream_response_time"
                "\tvhost:$host";
EOS
