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
import Entity
import AkidonComponents

protocol NewsViewModelInterface: AnyObject {
    var input: NewsViewModel.Input { get }
    var output: NewsViewModel.Output { get }
}

final class NewsViewModel: BaseViewModel<NewsViewModel>, NewsViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        let didTapNewsItem = PublishRelay<Int>()
    }

    struct Output: OutputType {
        let newsItems: Observable<[NewsItemModel]>
    }

    struct State: StateType {
        let newsItems: BehaviorRelay<[NewsItemModel]?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: NewsRouterInterface
        let newsItemsRSS: NewsItemsRSSInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let newsItems: PublishRelay<[NewsItemModel]> = .init()

        func getNewsItems() {
            dependency.newsItemsRSS.getNewsItems()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        state.newsItems.accept(response)
                        newsItems.accept(response)
                    },
                    onFailure: { error in
                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                getNewsItems()
            })
            .disposed(by: disposeBag)

        input.didTapNewsItem
            .subscribe { index in
                if let newsItems = state.newsItems.value,
                      let url = URL(string: newsItems[index].targetUrlStr) {
                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
                }
            }
            .disposed(by: disposeBag)

        return .init(
            newsItems: newsItems.asObservable()
        )
    }
}
