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
        let newsItemStoreUseCase: NewsItemStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let newsItems: PublishRelay<[NewsItemModel]> = .init()

        func getNewsItems() {
            dependency.newsItemsRSS.getNewsItems()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        dependency.newsItemStoreUseCase.assignmentNewsItems(response)
                        newsItems.accept(dependency.newsItemStoreUseCase.fetchNewsItems())
                        state.newsItems.accept(dependency.newsItemStoreUseCase.fetchNewsItems())
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
                getNewsItems()
            })
            .disposed(by: disposeBag)

        input.didTapNewsItem
            .subscribe { index in
                if let newsItems = state.newsItems.value,
                   let url = URL(string: newsItems[0].targetUrlStr) {
                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
                }
            }
            .disposed(by: disposeBag)

        return .init(
            newsItems: newsItems.asObservable()
        )
    }
}
