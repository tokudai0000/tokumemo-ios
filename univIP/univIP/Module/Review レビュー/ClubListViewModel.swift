//
//  ClubListViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/11.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol ClubListViewModelInterface: AnyObject {
    var input: ClubListViewModel.Input { get }
    var output: ClubListViewModel.Output { get }
}

final class ClubListViewModel: BaseViewModel<ClubListViewModel>, ClubListViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
//        let viewWillAppear = PublishRelay<Void>()
        let didTapWebItem = PublishRelay<String>()
    }

    struct Output: OutputType {
//        let newsItems: Observable<[NewsItemModel]>
    }

    struct State: StateType {
//        let newsItems: BehaviorRelay<[NewsItemModel]?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: ClubListRouterInterface
//        let newsItemsRSS: NewsItemsRSSInterface
//        let newsItemStoreUseCase: NewsItemStoreUseCaseInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
//        let newsItems: PublishRelay<[NewsItemModel]> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
//                getNewsItems()
            })
            .disposed(by: disposeBag)

        input.didTapWebItem
            .subscribe { urlStr in
                if let url = URL(string: urlStr) {
                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
                }
            }
            .disposed(by: disposeBag)

        return .init(
//            newsItems: newsItems.asObservable()
        )
    }
}
