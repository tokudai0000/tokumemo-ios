//
//  SettingsItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

struct SettingsItem {
    let title: String
    let id: SettingsItemType
    let url: String?
}

enum SettingsItemType {

    case password

    /// お気に入り登録
    case favorite

    /// 並び替え機能
    case customize

    case aboutThisApp

    case contactUs

    /// トクメモ＋のTwitter
    case officialSNS

    /// トクメモ＋のLit.linkホームページ
    case homePage

    case termsOfService

    case privacyPolicy

    /// univIPのGitHub
    case sourceCode
}
