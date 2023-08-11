//
//  HomeViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol HomeViewModelInterface: AnyObject {
    var input: HomeViewModel.Input { get }
    var output: HomeViewModel.Output { get }
}

final class HomeViewModel: BaseViewModel<HomeViewModel>, HomeViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let didTapPrItem = PublishRelay<Int>()
        let didTapUnivItem = PublishRelay<Int>()
        let didTapMenuCollectionItem = PublishRelay<Int>()
        let didSelectMenuDetailItem = PublishRelay<MenuDetailItem>()
        let didSelectMiniSettings = PublishRelay<HomeMiniSettingsItem>()
        let didTapTwitterButton = PublishRelay<Void>()
        let didTapGithubButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let prItems: Observable<[AdItem]>
        let univItems: Observable<[AdItem]>
        let menuDetailItem: Observable<[MenuDetailItem]>
    }

    struct State: StateType {
        let prItems: BehaviorRelay<[AdItem]?> = .init(value: nil)
        let univItems: BehaviorRelay<[AdItem]?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: HomeRouterInterface
        let adItemsAPI: AdItemsAPIInterface
        let adItemStoreUseCase: AdItemStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let prItems: PublishRelay<[AdItem]> = .init()
        let univItems: PublishRelay<[AdItem]> = .init()
        let menuDetailItem: PublishRelay<[MenuDetailItem]> = .init()

        func getAdItems() {
            dependency.adItemsAPI.getAdItems()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        dependency.adItemStoreUseCase.assignmentPrItems(response.prItems)
                        dependency.adItemStoreUseCase.assignmentUnivItems(response.univItems)

                        prItems.accept(dependency.adItemStoreUseCase.fetchPrItems())
                        univItems.accept(dependency.adItemStoreUseCase.fetchUnivItems())

                        state.prItems.accept(dependency.adItemStoreUseCase.fetchPrItems())
                        state.univItems.accept(dependency.adItemStoreUseCase.fetchUnivItems())
                    },
                    onFailure: { error in
                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                getAdItems()
            })
            .disposed(by: disposeBag)

        input.didTapPrItem
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { index in
                if let item = state.prItems.value?[index] {
                    dependency.router.navigate(.detail(item))
                }
            })
            .disposed(by: disposeBag)

        input.didTapUnivItem
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { index in
                if let item = state.univItems.value?[index],
                   let url = URL(string: item.targetUrlStr) {
                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
                }
            })
            .disposed(by: disposeBag)

        input.didTapMenuCollectionItem
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { index in
                let tappedCell = ItemsConstants().menuItems[index]

                switch tappedCell.id {
                case .courseManagement, .manaba, .mail:
                    if let url = tappedCell.targetUrl {
                        dependency.router.navigate(.goWeb(url))
                    }
                case .academicRelated:
                    menuDetailItem.accept(ItemsConstants().academicRelatedItems)
                case .libraryRelated:
                    menuDetailItem.accept(ItemsConstants().libraryRelatedItems)
                case .etc:
                    menuDetailItem.accept(ItemsConstants().etcItems)
                }
            })
            .disposed(by: disposeBag)

        input.didSelectMenuDetailItem
            .subscribe { item in
                if let url = item.element?.targetUrl {
                    dependency.router.navigate(.goWeb(url))
                }
            }
            .disposed(by: disposeBag)

        input.didSelectMiniSettings
            .subscribe { item in
                if let url = item.element?.targetUrl {
                    dependency.router.navigate(.goWeb(url))
                }
            }
            .disposed(by: disposeBag)

        input.didTapTwitterButton
            .subscribe { item in
                let url = Url.officialSNS.urlRequest()
                dependency.router.navigate(.goWeb(url))
            }
            .disposed(by: disposeBag)

        input.didTapGithubButton
            .subscribe { item in
                let url = Url.github.urlRequest()
                dependency.router.navigate(.goWeb(url))
            }
            .disposed(by: disposeBag)

        return .init(
            prItems: prItems.asObservable(),
            univItems: univItems.asObservable(),
            menuDetailItem: menuDetailItem.asObservable()
        )
    }
}


//    /// 大学図書館の種類
//    enum LibraryType {
//        case main // 常三島本館
//        case kura // 蔵本分館
//    }
//
//    /**
//     図書館の開館カレンダーPDFまでのURLRequestを作成する
//     PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
//     例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
//     例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
//     ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
//     <body class="index">
//     <ul>
//     <li class="pos_r">
//     <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
//     ========
//     aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
//     - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
//     - Returns: 図書館の開館カレンダーPDFまでのString
//     */
//    public func makeLibraryCalendarUrl(type: LibraryType) -> String? {
//        var urlString = ""
//        switch type {
//        case .main:
//            urlString = Url.libraryHomePageMainPC.string()
//        case .kura:
//            urlString = Url.libraryHomePageKuraPC.string()
//        }
//        let url = URL(string: urlString)! // fatalError
//        do {
//            // URL先WebページのHTMLデータを取得
//            let data = try NSData(contentsOf: url) as Data
//            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
//            // タグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
//            for node in doc.xpath("//a") {
//                // 属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
//                if let str = node["href"] {
//                    // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
//                    if str.contains("pub/pdf/calender/") {
//                        // PDFまでのURLを作成する(本館のURLに付け加える)
//                        return Url.libraryHomePageMainPC.string() + str
//                    }
//                }
//            }
//            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
//        } catch {
//            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
//        }
//        return nil
//    }
//
//    /**
//     今年度の成績表のURLを作成する
//
//     - Note:
//     2020年4月〜2021年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2020
//     2021年4月〜2022年3月までの成績は https ... Results_Get_YearTerm.aspx?year=2021
//     なので、2022年の1月から3月まではURLがyear=2021とする必要あり
//     - Returns: 今年度の成績表のURL
//     */
//    public func createCurrentTermPerformanceUrl() -> String {
//        var year = Calendar.current.component(.year, from: Date())
//        let month = Calendar.current.component(.month, from: Date())
//        if month <= 3 {
//            year -= 1
//        }
//        return Url.currentTermPerformance.string() + String(year)
//    }
//
//    /**
//     JavaScriptを動かしたい指定のURLか判定
//     ・JavaScriptを実行するフラグ
//     ・cアカウント、パスワードの登録確認
//     ・大学統合認証システム(IAS)のログイン画面の判定
//     ・それ以外なら
//     */
//    public func canExecuteJS(_ urlString: String) -> Bool {
////        if dataManager.canExecuteJavascript == false { return false }
//        if dataManager.cAccount.isEmpty || dataManager.password.isEmpty { return false }
//        if urlString.contains(Url.universityLogin.string()) { return true }
//        return false
//    }
//
//    /// タイムアウトのURLであるか判定
//    public func isTimeout(urlStr: String) -> Bool {
//        return urlStr == Url.universityServiceTimeOut.string() || urlStr == Url.universityServiceTimeOut2.string()
//    }
//}
