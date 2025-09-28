//
//  CreditsViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol CreditsViewModelInterface: AnyObject {
    var input: CreditsViewModel.Input { get }
    var output: CreditsViewModel.Output { get }
}

final class CreditsViewModel: BaseViewModel<CreditsViewModel>, CreditsViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapBackButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let creditItems: Observable<[CreditItemModel]>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: CreditsRouterInterface
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let creditsItems: PublishRelay<[CreditItemModel]> = .init()

        func convertAnyToAcknowItems(items: [Any]) -> [CreditItemModel] {
            var creditItems: [CreditItemModel] = []

            items.forEach { item in
                guard let item = item as? NSDictionary else { return }
                // titleとlicenseに値はあるが、contentsTextは空欄などに対応するべく、それぞれでアンラップする。
                let title = item["Title"] as? String ?? ""
                let license = item["License"] as? String ?? ""
                let contentsText = item["FooterText"] as? String ?? ""
                // contentsTextが非常に長文となるので、空欄のたびに改行することで利用者の可読性を高める
                let formatContentsText = contentsText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

                creditItems.append(CreditItemModel(title: title,
                                                   license: license,
                                                   contentsText: formatContentsText))
            }
            return creditItems
        }

        func loadAcknowItems() {
            guard let filePath = R.file.acknowledgementsPlist.url(),
                  let dic = NSDictionary(contentsOf: filePath),
                  var plistItems:[Any] = dic["PreferenceSpecifiers"] as? [Any] else {
                AKLog(level: .FATAL, message: "CreditPlist読み込みエラー")
                return
            }
            // 必要な情報は "最初と最後以外"
            plistItems.removeFirst()
            plistItems.removeLast()

            let creditItems = convertAnyToAcknowItems(items: plistItems)
            creditsItems.accept(creditItems)
        }

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                loadAcknowItems()
            })
            .disposed(by: disposeBag)

        input.didTapBackButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.back)
            })
            .disposed(by: disposeBag)

        return .init(
            creditItems: creditsItems.asObservable()
        )
    }
}
