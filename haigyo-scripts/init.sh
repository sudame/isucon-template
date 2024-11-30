#!/bin/bash

set -eux

cd $(dirname $0)/..

# pprotein-agentサービスのインストールと起動
echo "pprotein-agentサービスをインストール・起動しています..."
sudo cp ./haigyo-system-services/pprotein-agent.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable pprotein-agent
sudo systemctl start pprotein-agent

# ログディレクトリの所有権変更
echo "ログディレクトリの所有権を変更しています..."
sudo chown -R $USER:$USER ./var/log

# etcファイルのコピー、Gitに追加
echo "etcファイルをGit管轄下に入れています..."
git switch main
mkdir -p ./etc
sudo cp -RT /etc/nginx ./etc/nginx
sudo cp -RT /etc/mysql ./etc/mysql
sudo chown -R $USER:$USER ./etc
git add ./etc
git push origin main

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
