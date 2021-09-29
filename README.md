# Tokumemo

[![License: MIT](https://img.shields.io/github/license/akidon0000/univIP)](https://github.com/akidon0000/univIP/blob/main/LICENSE)
   
<p align="center" >
  <img src="/univIP/App/etc/Assets.xcassets/AppIcon.appiconset/TOKUMEMO_icon (1).png" width=300px>
</p>

# 概要
TokumemoはSwiftで開発された徳島大学生の学修を支援するアプリケーションです。

普段利用する大学Webサービスのログインを自動化、本日の授業や成績など知りたい情報をボタン1つで利用できます。



## スクリーンショット

<img src="https://user-images.githubusercontent.com/53287375/131691222-db0288ec-28a1-438c-b46c-549cfedcd985.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691249-0b38e0a7-d75f-4530-9778-be991fa0ef25.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691278-3853efe1-9487-4c60-ae3f-7ff196566c54.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/134928169-5e26628a-cc6b-474d-8822-cd56bfd3be3f.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691304-19214b9a-e921-4719-bf22-65aeb9c59948.png" width="320px">



## 開発背景

大学のWebサイトをスクレイピングしてハイブリッドアプリを作成したいと考えた。

## OS
・ iOS 14.4

## 仕様

## ライブラリ
- R.swift
- Kanna
- KeychainAccess
- mailcore2-ios

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

## Build方法
univIP/App/etc/password/mailAccountPassword.txtは
お問合せメールのパスワードが保存されているのでGitHubに保存していません。

自分で作成する必要があります。白紙でmailAccountPassword.txtを追加してもらうことで動きます。

---

# ライセンス

© 2021 akidon0000

Tokumemoは[MITライセンス](https://github.com/akidon0000/univIP/blob/main/LICENSE)のオープンソースプロジェクトです。

## オープンソース
本プロジェクトにご協力いただける方はWikiを参照してください。
