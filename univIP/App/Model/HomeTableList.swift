//
//  HomeTableList.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/17.
//

import Foundation

enum HomeTableItemType {

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

struct HomeTableItem {
    let title: String
    let id: HomeTableItemType
    let url: String?
}

let homeTableItemLists = [
    HomeTableItem(title: "PR画像(広告)の申請", id: .termsOfService, url: Url.prApplication.string()),
    HomeTableItem(title: "バグや新規機能の相談", id: .termsOfService, url: Url.contactUs.string()),
    HomeTableItem(title: "利用規約", id: .termsOfService, url: Url.termsOfService.string()),
    HomeTableItem(title: "プライバシーポリシー", id: .privacyPolicy, url: Url.privacyPolicy.string())]
