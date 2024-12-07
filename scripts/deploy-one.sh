#!/bin/bash

set -eux

cd $(dirname $0)/..

sudo cp -RT ./etc/nginx /etc/nginx
sudo systemctl restart nginx

sudo cp -RT ./etc/mysql /etc/mysql
sudo systemctl restart mysql

# ビルドなどそこらへんの処理を追加でその場で書く


