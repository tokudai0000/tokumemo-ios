//
//  AcknowledgementsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift
import Entity

protocol AcknowledgementsViewModelInterface: AnyObject {
    var input: AcknowledgementsViewModel.Input { get }
    var output: AcknowledgementsViewModel.Output { get }
}

final class AcknowledgementsViewModel: BaseViewModel<AcknowledgementsViewModel>, AcknowledgementsViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapBackButton = PublishRelay<Void>()
        let didTapAcknowledgementsItem = PublishRelay<Int>()
    }

    struct Output: OutputType {
        let acknowledgementsItems: Observable<[AcknowledgementsItemModel]>
    }

    struct State: StateType {
        let acknowledgementsItems: BehaviorRelay<[AcknowledgementsItemModel]?> = .init(value: nil)
    }

    struct Dependency: DependencyType {
        let router: AcknowledgementsRouterInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let acknowledgementsItems: PublishRelay<[AcknowledgementsItemModel]> = .init()

        func getAcknowledgement() {
            if let path = Bundle.url(forResource: "Acknowledgements",
                                     withExtension: "plist",
                                     subdirectory: nil,
                                     in: Bundle.main.url(forResource: "Settings", withExtension: "bundle")!) {
                var items: [Any] = []
                let dic = NSDictionary(contentsOf: path)!
                items = dic["PreferenceSpecifiers"] as! [Any]

                // 最初と最後以外が必要な情報
                items.removeFirst()
                items.removeLast()

                var items2: [AcknowledgementsItemModel] = []
                for i in 0..<items.count {
                    guard let item = items[i] as? NSDictionary,
                          let title = item["Title"] as? String,
                          let license = item["License"] as? String,
                          let contentsText = item["FooterText"] as? String else {
                        return
                    }
                    items2.append(AcknowledgementsItemModel(title: title, license: license, contentsText: contentsText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)))
                }

                state.acknowledgementsItems.accept(items2)
                acknowledgementsItems.accept(items2)
            }
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                getAcknowledgement()
            })
            .disposed(by: disposeBag)

        input.didTapBackButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.back)
            })
            .disposed(by: disposeBag)

        input.didTapAcknowledgementsItem
            .subscribe { index in
//                if let newsItems = state.newsItems.value,
//                      let url = URL(string: newsItems[index].targetUrlStr) {
//                    dependency.router.navigate(.goWeb(URLRequest(url: url)))
//                }
            }
            .disposed(by: disposeBag)

        return .init(
            acknowledgementsItems: acknowledgementsItems.asObservable()
        )
    }
}
