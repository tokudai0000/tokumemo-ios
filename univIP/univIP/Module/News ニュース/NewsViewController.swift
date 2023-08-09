//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift

class NewsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: NewsViewModelInterface!

    private let disposeBag = DisposeBag()

    //    private var viewActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension NewsViewController {
    func binding() {
        viewModel.output.newsItems
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.newsTableViewCell.identifier, cellType: NewsTableViewCell.self)) { index, model, cell in
                cell.configure(model: model)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension NewsViewController {
    private func configureTableView() {
        tableView.register(R.nib.newsTableViewCell)
        tableView.backgroundColor = AppConstants.Color.backGroundGray
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .black
    }

    // インジケーターは後日実装予定
//    private func setupIndicatorView() {
//        viewActivityIndicator = UIActivityIndicatorView()
//        viewActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        viewActivityIndicator.center = self.view.center
//        viewActivityIndicator.hidesWhenStopped = true
//        viewActivityIndicator.style = UIActivityIndicatorView.Style.medium
//        self.view.addSubview(viewActivityIndicator)
//    }
}
