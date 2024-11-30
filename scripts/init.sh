#!/bin/bash

cd $(dirname $0)/..

# pprotein-agentサービスのインストールと起動
sudo cp ./system-service/pprotein-agent.srevice /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable pprotein-agent
sudo systemctl start pprotein-agent

# ログディレクトリの所有権変更
sudo chown -R $USER:$USER ./var/log

# etcファイルのコピー、Gitに追加
git switch main
mkdir -p ./etc
sudo cp -r /etc/nginx ./etc/nginx
sudo cp -r /etc/mysql ./ect/mysql
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
