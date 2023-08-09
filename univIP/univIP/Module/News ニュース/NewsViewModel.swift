//
//  NewsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/06.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol NewsViewModelInterface: AnyObject {
    var input: NewsViewModel.Input { get }
    var output: NewsViewModel.Output { get }
}

/// ViewからのInputに応じで処理を行いOutputとして公開する
final class NewsViewModel: BaseViewModel<NewsViewModel>, NewsViewModelInterface {

    /// Viewからのイベントを受け取りたい変数を定義する
    struct Input: InputType {
        // PublishRelayは初期値がない
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let didTapNewsItem = PublishRelay<NewsListItemModel>()
    }

    /// Viewに購読させたい変数を定義する
    struct Output: OutputType {
        // Observableは値を流すことができない購読専用 (ViewからOutputに値を流せなくする)
        let sectionItems: Observable<[NewsListSectionModel]>
    }

    /// 状態変数を定義する(MVVMでいうModel相当)
    struct State: StateType {
        // BehaviorRelayは初期値があり､現在の値を保持することができる｡
    }

    /// Presentationレイヤーより上の依存物(APIやUseCase)や引数を定義する
    struct Dependency: DependencyType {
        let router: NewsRouterInterface
        let newsItemsRSS: NewsItemsRSSInterface
        let newsItemStoreUseCase: NewsItemStoreUseCaseInterface
    }

    /// Input, Stateからプレゼンテーションロジックを実装し､Outputにイベントを流す｡
    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let sectionItems: PublishRelay<[NewsListSectionModel]> = .init()

        func getNewsItems() {
            dependency.newsItemsRSS.getNewsItems()
//                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
//                .subscribe(
//                    onSuccess: { response in
//
//                    },
//                    onFailure: { error in
//                        AKLog(level: .ERROR, message: error)
//                    }
//                )
//                .disposed(by: disposeBag)

//            dependency.adItemsAPI.getAdItems()
//                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
//                .subscribe(
//                    onSuccess: { response in
//
//                    },
//                    onFailure: { error in
//                        AKLog(level: .ERROR, message: error)
//                    }
//                )
//                .disposed(by: disposeBag)
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
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                getNewsItems()
            })
            .disposed(by: disposeBag)

        input.didTapNewsItem
            .subscribe { item in
                print(item)
            }
            .disposed(by: disposeBag)

        // Stateが持つBizCardをTableViewで表示するために整形する
//        let sectionItemsObservable = state.bizCards.map { bizCards -> [HomeListSectionModel] in
//            let items = bizCards.map { bizCard -> (date: String, item: HomeListItemModel) in
//                let dateText = dependency.dateFormatUseCase.formatToYYYYMM(date: bizCard.createdAt)
//                let image = dependency.bizCardStoreUseCase.fetchImage(id: bizCard.id)
//                let item = HomeListItemModel(bizCard: bizCard, image: image)
//                return (dateText, item)
//            }
//            let groupedItems = Dictionary(grouping: items, by: { $0.date }).map { key, value in
//                HomeListSectionModel(dateText: key, items: value.map(\.item))
//            }
//            switch state.sortType.value {
//            case .createdAtASC:
//                return groupedItems.sorted(by: { $0.dateText < $1.dateText })
//            case .createdAtDESC:
//                return groupedItems.sorted(by: { $0.dateText > $1.dateText })
//            }
//        }
//        let test: [HomeListSectionModel] = []

        return .init(
//            sectionItems:
            sectionItems: sectionItems.asObservable()
        )
    }
}

//    public func updateNewsItems() {
//        state?(.busy) // 通信開始（通信中）
//        newsItems.removeAll()
//        apiManager.request(Url.newsItemJsonData.string(),
//                           success: { [weak self] (response) in
//            guard let self = self else {
//                AKLog(level: .FATAL, message: "[self] FatalError")
//                fatalError()
//            }
//            for i in 0 ..< 50 { // MAX50件
//                guard let title = response["items"][i]["title"].string,
//                      let date = response["items"][i]["pubDate"].string,
//                      let urlStr = response["items"][i]["link"].string else{
//                    break
//                }
//                let data = NewsData(title: title, date: date, urlStr: urlStr)
//                self.newsItems.append(data)
//            }
//            self.state?(.ready) // 通信完了
//        }, failure: { [weak self] (error) in
//            AKLog(level: .ERROR, message: "[API] userUpdate: failure:\(error.localizedDescription)")
//            self?.state?(.error) // エラー表示
//        })
//    }
//}
