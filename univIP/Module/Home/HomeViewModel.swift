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
import AkidonComponents

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
        let didTapMenuDetailItem = PublishRelay<MenuDetailItem>()
        let didTapMiniSettings = PublishRelay<HomeMiniSettingsItem>()
        let didTapTwitterButton = PublishRelay<Void>()
        let didTapGithubButton = PublishRelay<Void>()
        let didTapEventButton = PublishRelay<Int>()
    }

    struct Output: OutputType {
        let numberOfUsersLabel: Observable<String>
        let prItems: Observable<[AdItem]>
        let univItems: Observable<[AdItem]>
        let menuDetailItem: Observable<[MenuDetailItem]>
        let eventPopups: Observable<[HomeEventInfos.PopupItem]>
        let eventButtons: Observable<[HomeEventInfos.ButtonItem]>
    }

    struct State: StateType {
        let adItems: BehaviorRelay<AdItems?> = .init(value: nil)
        let eventButtons: BehaviorRelay<[HomeEventInfos.ButtonItem]?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: HomeRouterInterface
        let adItemsAPI: AdItemsAPIInterface
        let numberOfUsersAPI: NumberOfUsersAPIInterface
        let homeEventInfos: HomeEventInfosAPIInterface
        let libraryCalendarWebScraper: LibraryCalendarWebScraperInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let numberOfUsersLabel: PublishRelay<String> = .init()
        let prItems: PublishRelay<[AdItem]> = .init()
        let univItems: PublishRelay<[AdItem]> = .init()
        let menuDetailItem: PublishRelay<[MenuDetailItem]> = .init()
        let eventPopups: PublishRelay<[HomeEventInfos.PopupItem]> = .init()
        let eventButtons: PublishRelay<[HomeEventInfos.ButtonItem]> = .init()

        func getAdItems() {
            dependency.adItemsAPI.getAdItems()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        prItems.accept(response.adItems.prItems)
                        univItems.accept(response.adItems.univItems)

                        state.adItems.accept(response.adItems)
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

        func getHomeEventInfos() {
            dependency.homeEventInfos.getHomeEventInfos()
                .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onSuccess: { response in
                        eventPopups.accept(response.homeEventInfos.popupItems)
                        eventButtons.accept(response.homeEventInfos.buttonItems)
                        state.eventButtons.accept(response.homeEventInfos.buttonItems)
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
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                getAdItems()
                getNumberOfUsers()
                getHomeEventInfos()
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
                let tappedCell = AppConstants().menuItems[index]
                switch tappedCell.id {
                case .courseManagement, .manaba, .mail:
                    if let url = tappedCell.targetUrl {
                        dependency.router.navigate(.goWeb(url))
                    }
                case .academicRelated:
                    menuDetailItem.accept(AppConstants().academicRelatedItems)
                case .libraryRelated:
                    menuDetailItem.accept(AppConstants().libraryRelatedItems)
                case .etc:
                    menuDetailItem.accept(AppConstants().etcItems)
                }
            })
            .disposed(by: disposeBag)

        input.didTapMenuDetailItem
            .subscribe { item in
                guard let item = item.element,
                      let url = item.targetUrl else {
                    return
                }
                // 図書館のカレンダーについては、Webスクレイピングを実行する必要あり
                if item.id == .libraryCalendarMain || item.id == .libraryCalendarKura {
                    scrapeLibraryCalendar(with: url)
                }else{
                    dependency.router.navigate(.goWeb(url))
                }
            }
            .disposed(by: disposeBag)

        input.didTapMiniSettings
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

        input.didTapEventButton
            .subscribe { index in
                guard let index = index.element,
                      let eventButtons = state.eventButtons.value else {
                    return
                }

                let eventButton = eventButtons[index]
                if let url = URL(string: eventButton.targetUrlStr) {
                    let urlRequest = URLRequest(url: url)
                    dependency.router.navigate(.goWeb(urlRequest))
                }
            }
            .disposed(by: disposeBag)

        return .init(
            numberOfUsersLabel: numberOfUsersLabel.asObservable(),
            prItems: prItems.asObservable(),
            univItems: univItems.asObservable(),
            menuDetailItem: menuDetailItem.asObservable(),
            eventPopups: eventPopups.asObservable(),
            eventButtons: eventButtons.asObservable()
        )
    }
}
