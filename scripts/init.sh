#!/bin/bash

cd $(dirname $0)/..

# etcファイルのコピー
mkdir -p ./etc
sudo cp -r /etc/nginx ./etc/nginx
sudo cp -r /etc/mysql ./ect/mysql

# ログディレクトリの所有権変更
sudo chown -R $USER:$USER ./var/log

# Nginxの設定変更の促し
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
