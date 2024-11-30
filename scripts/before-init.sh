#!/bin/bash

#######################################
Git初期化よりも前にscpかなにかで送り込んで実行するスクリプト
#######################################

cd $(dirname $0)/..

# Gitの初期設定
git config --local user.name "haigyo"
git config --local user.email "haigyo@example.com"

# ghのインストール
sudo apt update
sudo apt install -y gh

# ghにログイン
gh auth login
