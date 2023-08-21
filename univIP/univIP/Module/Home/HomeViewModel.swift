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
        let numberOfUsersLabel: Observable<String>
        let prItems: Observable<[AdItem]>
        let univItems: Observable<[AdItem]>
        let menuDetailItem: Observable<[MenuDetailItem]>
    }

    struct State: StateType {
        let adItems: BehaviorRelay<AdItems?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: HomeRouterInterface
        let adItemsAPI: AdItemsAPIInterface
        let numberOfUsersAPI: NumberOfUsersAPIInterface
        let adItemStoreUseCase: AdItemStoreUseCaseInterface
        let libraryCalendarWebScraper: LibraryCalendarWebScraperInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let numberOfUsersLabel: PublishRelay<String> = .init()
        let prItems: PublishRelay<[AdItem]> = .init()
        let univItems: PublishRelay<[AdItem]> = .init()
        let menuDetailItem: PublishRelay<[MenuDetailItem]> = .init()

        func getAdItems() {
            dependency.adItemsAPI.getAdItems()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        dependency.adItemStoreUseCase.setAdItems(response.adItems)

                        let fetchAdItems = dependency.adItemStoreUseCase.fetchAdItems()
                        prItems.accept(fetchAdItems.prItems)
                        univItems.accept(fetchAdItems.univItems)

                        state.adItems.accept(fetchAdItems)
                    },
                    onFailure: { error in
                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        func getNumberOfUsers() {
            dependency.numberOfUsersAPI.getNumberOfUsers()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        numberOfUsersLabel.accept(response.numberOfUsers)
                    },
                    onFailure: { error in
                        AKLog(level: .ERROR, message: error)
                    }
                )
                .disposed(by: disposeBag)
        }

        func scrapeLibraryCalendar(with url: URLRequest) {
            dependency.libraryCalendarWebScraper.getLibraryCalendarURL(libraryUrl: url.url!)
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .observe(on: MainScheduler.instance) // メインスレッドでの処理を指定
                .subscribe(
                    onSuccess: { response in
                        dependency.router.navigate(.goWeb(response))
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
                getNumberOfUsers()
            })
            .disposed(by: disposeBag)

        input.didTapPrItem
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { index in
                if let item = state.adItems.value?.prItems[index] {
                    dependency.router.navigate(.detail(item))
                }
            })
            .disposed(by: disposeBag)

        input.didTapUnivItem
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { index in
                if let item = state.adItems.value?.univItems[index],
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
                guard let item = item.element,
                      let url = item.targetUrl else { return }

                if item.id == .libraryCalendarMain || item.id == .libraryCalendarKura {
                    scrapeLibraryCalendar(with: url)
                }else{
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
            numberOfUsersLabel: numberOfUsersLabel.asObservable(),
            prItems: prItems.asObservable(),
            univItems: univItems.asObservable(),
            menuDetailItem: menuDetailItem.asObservable()
        )
    }
}
