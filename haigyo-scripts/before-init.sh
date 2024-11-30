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

set -eux

cd $HOME/webapp

# Gitの初期設定
echo "Gitの初期設定を行います..."
git config --global user.name "haigyo"
git config --global user.email "haigyo@example.com"
git config --global init.defaultBranch main

# Gitの初期化
echo "Gitレポジトリの初期化を行います..."
git init

# ghのインストール
echo "ghをインストールします..."
sudo apt update
sudo apt install -y gh

# ghにログイン
echo "ghにログインします..."
gh auth login

# テンプレートレポジトリを追加
echo "テンプレートレポジトリをローカルレポジトリに反映します..."
git remote add origin $1
git fetch origin
git merge --allow-unrelated-histories origin/main

# scripts配下のファイルに実行権限を付与
echo "scripts配下のファイルに実行権限を付与します..."
chmod +x ./haigyo-scripts/*.sh

# 変更をリモートレポジトリに反映
echo "変更をリモートレポジトリに反映します..."
git push --set-upstream origin main
