# Tokumemo

[![License: MIT](https://img.shields.io/github/license/akidon0000/univIP)](https://github.com/akidon0000/univIP/blob/main/LICENSE)
   
<p align="center" >
  <img src="/univIP/App/etc/Assets.xcassets/AppIcon.appiconset/TOKUMEMO_icon (1).png" width=300px>
</p>

TokumemoはSwiftで開発された徳島大学生の学修を支援するアプリケーションです。

普段利用する大学Webサービスのログインを自動化、本日の授業や成績など知りたい情報をボタン1つで利用できます。



## スクリーンショット

<img src="https://user-images.githubusercontent.com/53287375/131691222-db0288ec-28a1-438c-b46c-549cfedcd985.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691249-0b38e0a7-d75f-4530-9778-be991fa0ef25.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691278-3853efe1-9487-4c60-ae3f-7ff196566c54.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691291-6d31ef82-547e-48d0-ba71-0f5252b88ce1.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691304-19214b9a-e921-4719-bf22-65aeb9c59948.png" width="320px">



## 開発背景

普段、利用する大学Webサービスは毎回パスワードの入力が必要ですが、入力の手間暇を軽減する為、自動で


頻繁に利用する大学Webサービスは大変便利で重宝しています。　　　　

しかし、頻繁に利用するからこそ、さらに便利になれるアプリを制作してみようと思いました。



## 使用技術

- Swift
- CocoaPods(R.swift, KeychainAccess, mailcore2-ios)



## 機能一覧

- 大学Webサービス表示（教務事務システム、　マナバ、　図書館サイト、　シラバスなど）
- Webサービスに自動ログイン
- 開発者へ連絡機能



## 工夫点

初めて使う方でも理解しやすいように設計した。

頻繁に使う「教務事務システム、マナバ」は下のタブバーに配置、たまに使う程度であればナビゲーションバーからのハンバーガーメニューで表示などの工夫を行った。

また、初回起動時にパスワード入力画面を表示させることで、このアプリケーションの最大のメリットを理解させることができると考えた。

コードの方では、
プロジェクトの分割、コメントによる可読性、実装するか定かではない機能にはブランチを作成し柔軟に開発を行った。



## セキュリティー

フレームワークである「KeychainAccess」を使用して
KeyChainに保存しています。

万が一、セキュリティ上に脆弱性を発見された場合には、問題を公表する前に、「tokumemo1@gmail.com」までお知らせいただき、対応させていただきたいと思います。



## ライセンス

© 2021 akidon0000

Tokumemoは[MITライセンス](https://github.com/akidon0000/univIP/blob/main/LICENSE)のオープンソースプロジェクトです。






# サービス内容
以下他の学生が開発に参加する際、参考になる内容を記載します。


## ログイン
evaluateJavaScriptを使用し、HTML側でJavaScriptを動かす。
ログインURLより、ログイン画面からcアカウント、パスワードを入力、ボタンを押す。
ログイン画面からcアカウント、パスワードをevaluateJavaScriptを使用して入力、ボタンを押す。
WKWebViewにCookieがあるので、ログイン後から一定時間は再度ログインを求められることはない。

## 教務事務システム
登録者は教務事務システムを、非登録者はシステムサービス一覧を表示。
登録者の場合は
アンケートの催促画面が表示されるので、evaluateJavaScriptでボタンを押す。

## マナバ
登録者はマナバを、非登録者はeラーニング一覧を表示。

## 図書館
登録者はマイライブラリを、非登録者は図書館ホームページを表示。

## シラバス
科目名、教員名、キーワードをシラバスサイトへそれぞれevaluateJavaScriptを使用して入力、ボタンを押す。
シラバスサイトは(HTTP)である為、AppTransportSecuritySettingsの設定を行なった。

## 許可ドメイン
サブドメインを含む「tokushima-u.ac.jp」のみ許可しています。
それ以外のサイトに移る場合は、強制にSafariで起動するようにしています。

## ｃアカウント、パスワード保存方法
フレームワークである「KeychainAccess」を使用して
KeyChainに保存します
univIP/App/Model/DataManager.swift
に詳細を書いています。

## Build方法
univIP/App/etc/R.generatedと
univIP/App/etc/password/mailAccountPassword.txtは
GitHubに保存しないため、自分で作成する必要があります
mailAccountPassword.txtは白紙で追加してもらうことで動きます。



このソースコードはMITライセンスで配布されています。詳しくはLICENSEをご覧ください。

質問やコメント、ご意見をお待ちしています。
