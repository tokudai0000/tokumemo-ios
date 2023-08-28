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
import Core
import Entity

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
        let clientName: Observable<String>
        let imageUrlStr: Observable<String>
        let imageDescription: Observable<String>
    }

    struct State: StateType {
    }

    struct Dependency: DependencyType {
        let router: PRRouterInterface
        let prItem: AdItem
    }

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output {
        let clientName: PublishRelay<String> = .init()
        let imageUrlStr: PublishRelay<String> = .init()
        let imageDescription: PublishRelay<String> = .init()

        input.viewDidLoad
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { _ in
                clientName.accept(dependency.prItem.clientName)
                imageUrlStr.accept(dependency.prItem.imageUrlStr)
                imageDescription.accept(dependency.prItem.imageDescription)
            })
            .disposed(by: disposeBag)

        input.didTapDetailsInfoButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if let url = URL(string: dependency.prItem.targetUrlStr) {
                    let urlRequest = URLRequest(url: url)
                    dependency.router.navigate(.goWeb(urlRequest))
                }
            })
            .disposed(by: disposeBag)
        
        input.didTapCloseButton
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                dependency.router.navigate(.close)
            })
            .disposed(by: disposeBag)
        
        return .init(
            clientName: clientName.asObservable(),
            imageUrlStr: imageUrlStr.asObservable(),
            imageDescription: imageDescription.asObservable()
        )
    }
}
