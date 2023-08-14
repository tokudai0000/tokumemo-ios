//
//  PrViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/10.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import RxRelay
import RxSwift

protocol PRViewModelInterface: AnyObject {
    var input: PRViewModel.Input { get }
    var output: PRViewModel.Output { get }
}

final class PRViewModel: BaseViewModel<PRViewModel>, PRViewModelInterface {

    struct Input: InputType {
        let viewDidLoad = PublishRelay<Void>()
        let didTapDetailsInfoButton = PublishRelay<Void>()
        let didTapCloseButton = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let imageStr: Observable<String>
        let clientName: Observable<String>
        let text: Observable<String>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: PRRouterInterface
        let prItem: AdItem
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let imageStr: PublishRelay<String> = .init()
        let clientName: PublishRelay<String> = .init()
        let text: PublishRelay<String> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)) // ユーザーの操作を阻害しない
            .subscribe(onNext: { _ in
                imageStr.accept(dependency.prItem.imageUrlStr)
                clientName.accept(dependency.prItem.clientName)
                text.accept(dependency.prItem.imageDescription)
            })
            .disposed(by: disposeBag)

        input.didTapDetailsInfoButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let urlStr = dependency.prItem.targetUrlStr
                let url = URL(string: urlStr)!
                let urlRequest = URLRequest(url: url)
                dependency.router.navigate(.goWeb(urlRequest))
            })
            .disposed(by: disposeBag)
        

        input.didTapCloseButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.close)
            })
            .disposed(by: disposeBag)
        
        return .init(
            imageStr: imageStr.asObservable(),
            clientName: clientName.asObservable(),
            text: text.asObservable()
        )
    }
}
