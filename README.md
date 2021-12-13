# Tokumemo

[![License: MIT](https://img.shields.io/github/license/akidon0000/univIP)](https://github.com/akidon0000/univIP/blob/main/LICENSE)
   
<p align="center" >
  <img src="/univIP/App/etc/Assets.xcassets/AppIcon.appiconset/1024.png" width=300px>
</p>

# 概要
トクメモは日々のパスワード入力、煩雑なボタンクリックを自動化する、徳島大学専用の学修サポートアプリです。


## スクリーンショット

<img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_courceManagementMobile.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_manabaPC.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_mail.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_library.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_syllabus.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_libraryCalendar.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_setting1.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_setting2.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_password.png" width="320px"><img src="https://github.com/akidon0000/univIP/blob/main/IMG/5.5inch/5.5inch_career.png" width="320px">

## 開発背景

大学のWebサイトをスクレイピングしてハイブリッドアプリを作成したいと考えた。

## 仕様

## ライブラリ
- R.swift
- Kanna
- KeychainAccess
- Firebase/Analytics

## 機能一覧
- 自動ログイン機能（時間制限による強制ログアウトにも対応）
- 大学Webサービス表示（教務事務システム、　マナバ、　図書館サイト）
- シラバス検索機能

## 工夫点
毎日利用しやすいように工夫を重ねた。

学生の立場から使いやすい操作手順（タップ回数削減）に変更した。

例えば、「ログインするのに必要だったタップ回数を3回から0回へ」「成績参照までを11回から2回へ」など他にも工夫を重ねた

時間制限による強制ログアウトでエラーが発生し、改めてログインする必要があり面倒だったのを、自動でエラー回避した上でログインする様にした。

アプリの透明性をアピールし、同じ大学の仲間からアドバイスが受けられる様に、GitHubで公開した。

オープンソースにするにあたって、コメントを増やし可読性を高めた。


## 自己評価
およそ1ヶ月程度使った結果、当初想定していた使いやすいアプリケーションにできたと考える。
ネイティブと変わらないレスポンスで快適に使えている。
利用する友人も徐々にではあるが増えてきており、意見を求めて改善していきたいと思う。

## 今後していきたい事
・　他学生が運営しているWebサイトとの連携
・　Android版の開発


---

# SetUp
・CocoaPodsのバージョンを揃えるためにBundlerを使用しています。
Bundlerインストール後
$ bundle exec pod install

・Xcodeのバージョンを揃えるため
Xcode13.1での動作を行なってください。

# ライセンス

© 2021 akidon0000

トクメモは[MITライセンス](https://github.com/akidon0000/univIP/blob/main/LICENSE)のオープンソースプロジェクトです。

## オープンソース
本プロジェクトにご協力いただける方はWikiを参照してください。
