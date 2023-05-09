# トクメモ＋ (TokumemoPlus) for iOS

<!-- [![Release](https://img.shields.io/github/v/release/tokudai0000/univIP)](https://github.com/tokudai0000/univIP/release/latest) -->

[![License: MIT](https://img.shields.io/github/license/tokudai0000/univIP)](https://github.com/tokudai0000/univIP/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)](https://github.com/tokudai0000/univIP)
[![Twitter](https://img.shields.io/twitter/follow/tokumemo0000?style=social)](https://twitter.com/tokumemo0000)

|Branch|CI|
|:--|:--|
|[main](https://github.com/tokudai0000/univIP/tree/main)|[![CI](https://github.com/tokudai0000/univIP/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/tokudai0000/univIP/actions/workflows/main.yml)|
|[develop](https://github.com/tokudai0000/univIP/tree/develop)|[![CI](https://github.com/tokudai0000/univIP/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/tokudai0000/univIP/actions/workflows/main.yml)|

[![Download_on_the_App_Store_Badge](./Docs/Download_on_the_App_Store_Badge.svg)](https://apps.apple.com/jp/app/id1582738889)


<p align="center" >
  <img src="./Docs/TokumemoPlusIcon.png" width=300px>
</p>


# 概要
トクメモ＋は、[徳島大学生](https://github.com/akidon0000)が徳島大学のWebサービスの不便さを解消する目的で個人で開発したアプリ「トクメモ」が原点です。2022年4月に徳島大学イノベーションプラザで始まった「アプリ開発プロジェクト」により、トクメモの機能やUIデザインが刷新され、「トクメモ＋」として生まれ変わりました。

トクメモ＋は、徳島大学生のための学習支援アプリとして、自動ログインや部活動情報集約などの便利な機能を提供しています。開発は、大学側からAPIが提供されていないため、WebサイトスクレイピングやJavaScriptインジェクションを駆使して情報を収集しました。また、情報の透明性と外部意見の取り込みを目指して、オープンソース化を実施し、保守性の高いコードを意識して開発が進められました。

2023年2月に「アプリ開発プロジェクト」は解散しましたが、現時点では2025年3月までアプリの運用を続ける予定です。現在、トクメモ＋はAndroid版も含め、徳島大学生の3人に1人（約2500人）が利用しています。アプリの更なる普及と改善を目指し、徳島大学生の充実した大学生活をサポートすることを目標に、今後も活動が続けていきます。


# トクメモ＋紹介動画

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/zRVeZhip5ow/0.jpg)](https://www.youtube.com/watch?v=zRVeZhip5ow)
※Youtubeへ遷移します


# スクリーンショット

|ホーム画面|ニュース画面|設定画面|
|:--|:--|:--|
|<img src="Docs/Screenshots/5.5inch/5.5inch_home.png" width="207">|<img src="Docs/Screenshots/5.5inch/5.5inch_news.png" width="207">|<img src="Docs/Screenshots/5.5inch/5.5inch_settings.png" width="207">|

|教務事務システム|マナバ|Outlookメールサービス|
|:--|:--|:--|
|<img src="Docs/Screenshots/5.5inch/5.5inch_courseManagementMobile.png" width="207">|<img src="Docs/Screenshots/5.5inch/5.5inch_manabaPC.png" width="207">|<img src="Docs/Screenshots/5.5inch/5.5inch_mail.png" width="207">|

|パスワード画面|カスタマイズ画面|
|:--|:--|
|<img src="Docs/Screenshots/5.5inch/5.5inch_password.png" width="207">|<img src="Docs/Screenshots/5.5inch/5.5inch_customize.png" width="207">|


## ライブラリ
- R.swift
- Alamofire
- SwiftyJSON
- Firebase/Analytics
- KeychainAccess // KeychainをUserDefautsのように操作する為
- Kanna // Webスクレイピングを行う為


# トクメモ＋の機能紹介

## 主要機能
- 大学Webサービス（manaba、教務システムなど）への自動ログイン
- 18種類の大学Webページへの簡単アクセス
- 徳大Newsの閲覧
- 徳大の学生団体情報

## 機能詳細

### 大学Webサービス（manaba、教務システムなど）への自動ログイン
manabaや教務システムなど、大学Webサービスへ簡単にアクセスできます。お気に入りから探す手間が省け、ログイン済みの状態でページが開くことが出来ます。

### 18種類の大学Webページへの簡単アクセス
忙しい朝に教務、manaba、メールなどを素早く開いて大学からのお知らせをチェックできます。システム間の移動もボタン一つでスムーズに行えます。

### 徳大Newsの閲覧
徳島大学のホームページに掲載されているNewsをアプリで確認できます。これで徳大の最新情報を逃さずチェックできます。

### 徳大の学生団体情報の集約
徳島大学で活動する部活動・サークル・学生団体についての情報を一箇所で確認できます。これにより、学生団体の活動やイベントに関する情報を簡単に入手できます。

## 対応する大学Webサービス一覧
- 教務システム
- マナバ
- 図書館Webサイト
- 図書館MyPage
- 図書館本貸し出し期間延長
- 図書館本購入リクエスト
- 図書館開館カレンダー
- シラバス
- 時間割
- 今年の成績表
- 出欠記録
- 授業アンケート
- メール
- キャリアセンター
- 生協の営業時間
- 生協の食堂メニュー
- 履修登録
- システムサービス一覧
- Eラーニング一覧
- 大学サイト
- 学びサポート企画部のSSSカレンダー
- 知っておきたい防災情報

今後も更新予定



|ビラ|
|:--|
|<img src="Docs/その他.png" width="207">|


## 募集中

ご協力いただけると幸いです :)

- [New issue](https://github.com/tokudai0000/univIP/issues/new)
- [New pull request](https://github.com/tokudai0000/univIP/compare)


## ライセンス

Copyright(c) 2023 tokudai0000

トクメモ＋は[MITライセンス](https://github.com/tokudai0000/univIP/blob/main/LICENSE)のオープンソースプロジェクトです。


## ホームページ

[![IMAGE ALT TEXT HERE](./Docs/homepage.png)](https://lit.link/developers)
※画像をタップすると遷移します
