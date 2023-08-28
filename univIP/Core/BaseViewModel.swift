//
//  BaseViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/05.
//

import Foundation
import RxSwift

public protocol InputType {}
public protocol OutputType {}
public protocol StateType {}
public protocol DependencyType {}

public protocol ViewModelType: AnyObject {
    associatedtype Input: InputType
    associatedtype Output: OutputType
    associatedtype State: StateType
    associatedtype Dependency: DependencyType

    static func bind(input: Input, state: State, dependency: Dependency, disposeBag: DisposeBag) -> Output
}

public typealias BaseViewModel<ViewModel: ViewModelType> = PrimitiveBaseViewModel<ViewModel> & ViewModelType

open class PrimitiveBaseViewModel<ViewModel: ViewModelType> {
    public let input: ViewModel.Input
    public let output: ViewModel.Output

    private let state: ViewModel.State
    private let dependency: ViewModel.Dependency
    private let disposeBag = DisposeBag()

    public init(input: ViewModel.Input, state: ViewModel.State, dependency: ViewModel.Dependency) {
        self.input = input
        self.output = ViewModel.bind(input: input, state: state, dependency: dependency, disposeBag: disposeBag)
        self.state = state
        self.dependency = dependency
    }
}
