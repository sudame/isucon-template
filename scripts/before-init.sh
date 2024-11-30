#!/bin/bash

#######################################
# Git初期化よりも前にscpかなにかで送り込んで実行するスクリプト
#
# 使いかた:
# ./before-init.sh <テンプレートレポジトリのURL>
#
# 確認事項:
# - 例年同様 $HOME/webapp ディレクトリが存在するか？
#######################################

cd $HOME/webapp

# Gitの初期設定
git config --global user.name "haigyo"
git config --global user.email "haigyo@example.com"
git config --global init.defaultBranch main

# Gitの初期化
git init

# ghのインストール
sudo apt update
sudo apt install -y gh

# ghにログイン
gh auth login

# テンプレートレポジトリを追加
git remote add origin $1
git fetch origin
git merge --allow-unrelated-histories origin/main
git push --set-upstream origin main
