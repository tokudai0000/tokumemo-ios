<p align="center" >
  <img src="./Docs/TokumemoPlusIcon.png" width=150px>
</p>

# トクメモ＋ (TokumemoPlus) for iOS


[![Download_on_the_App_Store_Badge](./Docs/Download_on_the_App_Store_Badge.svg)](https://apps.apple.com/jp/app/id1582738889)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)](https://github.com/tokudai0000/univIP)
[![License: MIT](https://img.shields.io/github/license/tokudai0000/univIP)](https://github.com/tokudai0000/univIP/blob/main/LICENSE)
[![Twitter](https://img.shields.io/twitter/follow/tokumemo0000?style=social)](https://twitter.com/tokumemo0000)


|Branch|CI|
|:--|:--|
|[main](https://github.com/tokudai0000/univIP/tree/main)|[![CI](https://github.com/tokudai0000/univIP/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/tokudai0000/univIP/actions/workflows/main.yml)|
|[develop](https://github.com/tokudai0000/univIP/tree/develop)|[![CI](https://github.com/tokudai0000/univIP/actions/workflows/main.yml/badge.svg?branch=develop)](https://github.com/tokudai0000/univIP/actions/workflows/main.yml)|


## 開発環境
- Xcodeバージョン: 14.2


## 動作環境
- deployment target: iOS 15.0
- cocoapod 1.12.1

## 準備
1. ライブラリインストール
   1. bundlerをインストールする
   ```
   bundle install
   ```
   2. podからライブラリをインストールする
   ```
   bundle exec pod install
   ```
2. `univIP.xcworkspace` からプロジェクトを開く


## このアプリについて
### 概要
**トクメモ＋は、徳島大学のWebサービスの不便さを解消するアプリで、[個人開発](https://github.com/akidon0000)の「トクメモ」が原点です。**
本アプリは、徳島大学の講義情報やレポート提出、そして学内情報などの一元化を目的としており、それにはJavaScriptインジェクション、Webスクレイピング、そしてRSSフィードを活用し、学生生活のほとんどが一つのアプリで完結するという形で実現しました。

開発では、大学側がAPIを提供していないため、WebスクレイピングとJavaScriptインジェクションを用いて情報収集を行いました。
具体的に、Webスクレイピングでは図書館の開館表がpdfとしてHTMLのボタン内に埋め込まれています。開館表に修正が入ったとしても対応させました。
また、JavaScriptインジェクションでは、SSOのSAML認証を行うログイン画面にてIDとパスワード、次へ進むボタンの3つをモバイル側からWebページ側へJavaScriptを送り実行させることで自動化させました。

このアプリについての[発表スライド](https://www.slideshare.net/ssuser4a1300/pptx-259338451)


### 紹介動画

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/zRVeZhip5ow/0.jpg)](https://www.youtube.com/watch?v=zRVeZhip5ow)
※Youtubeへ遷移します


### アプリデザイン

[Figma](https://www.figma.com/file/ipPuYmdf2dsy6Y8OUY4ssV/TokumemoPlus?type=design&node-id=0%3A1&mode=design&t=yytdAd5PPkF9qCPC-1)で設計を行っています。


### 画面
- ルート画面(RootViewController)
  - スプラッシュ画面、規約同意画面、メイン画面を子ViewControllerとして持つ

- スプラッシュ画面 (Splash)
  - APIにより、最新の利用規約バージョンを取得。[APIリンク](https://tokudai0000.github.io/tokumemo_resource/api/v1/current_term_version.json)
  - UserDefaultsにより端末内に保存されている同意した規約verと最新verを比較しする。
    - 一致する場合は同意しているとみなし、ログイン処理を実行したのちMainViewへ遷移
    - 異なる場合は同意していないとみなしAgreementViewへ最新の規約verを渡し遷移
  - ログイン処理は、SSOのSAML認証を行うログイン画面にてIDとパスワード、次へ進むボタンの3つをモバイル側からWebページ側へJavaScriptを送り実行。完了後のURLを検知し、ログイン成功とみなしMainViewへ遷移
  - 画面の表示時間は最大10秒(まれに、ログイン処理が完了しない場合があるため)

- 規約同意画面 (Agreement)
  - スプラッシュ画面から最新の規約verを受け取る
  - APIにより、最新の規約文章を取得。[APIリンク](https://tokudai0000.github.io/tokumemo_resource/api/v1/term_text.json)
  - 利用規約とプライバシーポリシーを必要に応じでWKWebViewを用いて表示
  - 同意ボタンを押すとUserDefaultsに最新の規約verを保存しMainViewへ遷移

- メイン画面 (MainView)
  - メイン画面は、タブバーを用いて4つの画面を切り替える(初期はホーム画面)
    - ホーム画面、ニュース画面、部活・サークル一覧画面、設定画面

- ホーム画面 (Home)
  - APIにより、現在の利用者数と広告情報を取得。[現在の利用者数APIリンク](https://tokudai0000.github.io/tokumemo_resource/api/v1/number_of_users.json) & [広告情報APIリンク](https://tokudai0000.github.io/tokumemo_resource/api/v1/ad_items.json)
  - 画面上部には、現在の利用者数を表示
  - 広告として2つの種類がある。
    - PR画像
      - 徳島大学生から徳島大学生に向けた告知画像
    - Univ画像
      - 徳島大学関係者(教職員)から徳島大学生に向けた告知画像
  - PR画像をタップするとDetailViewに構造体AdItemを渡し遷移し、Univ画像をタップするとWebViewに遷移する
  - MenuCollectionViewには6つの種類がある。
    - 教務システム(courseManagement)
      - 教務システムのWebViewへ遷移
    - manaba(manaba)
      - manabaのWebViewへ遷移
    - メール(mail)
      - メールのWebViewへ遷移
    - 講義関連(academicRelated)
      - 時間割(timeTable)
      - 今学期の成績(currentTermPerformance)
      - シラバス(syllabus)
      - 出欠記録(presenceAbsenceRecord)
      - すべての成績(termPerformance)
    - 図書館関連(libraryRelated)
      - 常三島図書館 カレンダー(libraryCalendarMain)
      - 蔵本図書館 カレンダー(libraryCalendarKura)
      - 貸出図書の期間延長(libraryBookLendingExtension)
      - 本の購入リクエスト(libraryBookPurchaseRequest)
      - マイページ(libraryMyPage)
    - その他(etc)
      - 生協営業時間(coopCalendar)
      - 食堂メニュー(tokudaiCoopDinigMenu)
      - キャリア支援室(tokudaiCareerCenter)
      - SSS学習支援室の時間割(studySupportSpace)
      - 命を守る防災知識(disasterPrevention)
    上記のMenuCollectionViewの各セルをタップすると、例外の2つを除き各画面へWebViewへURLを渡し遷移する
    - 例外：図書館関連の「常三島図書館 カレンダー」「蔵本図書館 カレンダー」
      - これらのセルをタップすると、図書館WebサイトにWebスクレイピングを行い、カレンダーのPDFリンクを取得。その後WebViewへURLを渡し遷移する
  - MiniTableViewには5つの種類がある
    - PR画像(広告)の申請
    - お問い合わせ
    - ホームページ
    - 利用規約
    - プライバシーポリシー
    それぞれ対応したWebViewへURLを渡し遷移する
  - 画面下部には、X(Twitter)とGitHubのアイコンを表示。それぞれWebページへURLを渡し遷移する

- ニュース画面 (News)
  - 徳島大学が提供しているRSSからニュース情報を取得[RSSリンク](https://www.tokushima-u.ac.jp/recent/rss.xml)
  - 取得したデータをライブラリKannaを用いてパースし、ニュースのタイトルとリンク、日付を取得
  - ニュースのタイトルをタップすると、WebViewへURLを渡し遷移する

- 部活・サークル一覧画面(ClubLists)
  - 画面にWKWebViewを表示し、自作した[部活・サークル一覧ページ](https://tokudai0000.github.io/club-list/)を表示する
  - 部活動をタップした時、HTML側からSwift側にデータ(URL)を渡し、そのURLをWebViewへ渡し遷移する
  JavaScript相互通信 等を参照

- 設定画面(Settings)

- 入力画面(Input)
  - 大学のWebサービスにログインする際に必要な学生IDとパスワードをここでKeyChainに保存する
  - 画面生成時、登録してある学生IDをTextFieldに表示する**パスワードは生体認証等無く再表示させてはいけない**
  - 同意書ボタンを押すとHelpmessageAgree画面へ遷移する
  - リセットボタンでは、KeyChainに保存してある学生IDとパスワードを空の文字列に置換する
  - 保存ボタンでは、TextFieldに入力された学生IDとパスワードをKeyChainに保存し、完了するとアラートにより登録完了を知らせる

- 同意書画面(HelpmessageAgree)
  - APIにより、同意書の内容を取得する。[同意書APIリンク](https://tokudai0000.github.io/tokumemo_resource/api/v1/helpmessage_agree.json)
  - この同意書は大学が提供しているものを使用している。大学Webサービスからと学生への同意書である。**トクメモ＋はこの内容に関与していない**

- 詳細画面(Detail)
  - Home画面のPR画像をタップすると、構造体AdItemを渡し遷移する
  - AdItemのtitleとurlを表示し、urlをタップするとWebViewへ遷移する

- ウェブ画面(Web)
  - 渡されたURLをWKWebViewで表示する
  - URL読み込み前
    - タイムアウト表示になっていないか確認する
  - URL読み込み完了
    - ログイン処理を実行するJavaScriptInjectionを動かすべきか判定する
    - メールサービスのログイン処理を実行するJavaScriptInjectionを動かすべきか判定する
    - キャリアセンターのログイン処理を実行するJavaScriptInjectionを動かすべきか判定する


## アーキテクチャ
**MVVMをベースにClean Architectureを参考にしたものになっています**
- [MVVM+CreanArchtecture](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)

<img src="./Docs/mvvmr.png" width="800px">

### Router
- Moduleの初期化を行い､ViewModelに依存物を渡す
- ViewModelから画面遷移の命令が来たら､別のModuleのRouterを初期化し遷移を行う
### ViewModel
- Viewからのイベントに応じてプレゼンテーションロジックを実行し､Viewの状態を変更する
- 必要に応じてUseCaseやAPIを用いてデータの取得を行う
- Routerを所持することで､プレゼンテーションロジックによる処理後に画面遷移を行うことが可能
### View (Controller)
- 画面のレイアウトを行う
- 状態に応じて変化する要素はViewModelに従う
### UseCase
- プレゼンテーションロジック以外のビジネスロジックの実装を行う
- データの変換処理や､データ取得処理等
### Entity
- アプリ内で共通のデータモデル
- APIからのレスポンス等もここでDecodableに準拠したモデルにする
### Repository
- アプリ内で複数のモジュールで必要なデータや永続化が必要なデータを保持する
- データの永続化にはUserDefaults、KeyChainを用いる
### API
- 外部のAPIサーバーと通信を行う｡
- 本プロジェクトではAPIKitというライブラリを利用しており､DataLayer部分の処理をライブラリ内で行っている｡ そのためAPIの利用箇所がDomainLayerとなり、アプリのコード内ではViewModelから直接APIクラスを利用している



## 使用ライブラリ

- Kanna
- APIKit
- R.swift
- RxCocoa
- RxSwift
- RxGesture
- KeychainAccess
- Firebase/Analytics
- FirebaseCrashlytics



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
