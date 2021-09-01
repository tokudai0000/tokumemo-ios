# トクメモ(UniversityInformationPortal)

徳島大学の学修を支援するアプリです。

## デモ画像
<img src="https://user-images.githubusercontent.com/53287375/131691222-db0288ec-28a1-438c-b46c-549cfedcd985.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691249-0b38e0a7-d75f-4530-9778-be991fa0ef25.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691278-3853efe1-9487-4c60-ae3f-7ff196566c54.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691291-6d31ef82-547e-48d0-ba71-0f5252b88ce1.png" width="320px"><img src="https://user-images.githubusercontent.com/53287375/131691304-19214b9a-e921-4719-bf22-65aeb9c59948.png" width="320px">


頻繁に利用する大学Webサービスは大変便利で重宝しています。
しかし、頻繁に利用するからこそ、さらに便利になれるアプリを制作してみようと思いました。

## ログイン
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
