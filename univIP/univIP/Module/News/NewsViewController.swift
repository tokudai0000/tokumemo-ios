//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import RxSwift
import Entity

class NewsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    //    private var viewActivityIndicator: UIActivityIndicatorView!

    private let disposeBag = DisposeBag()
    
    var viewModel: NewsViewModelInterface!

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
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let self = self {
                    self.viewModel.input.didTapNewsItem.accept(indexPath.row)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.output
            .newsItems
            .bind(to: tableView.rx.items(cellIdentifier: UnivNewsTableCell.Reusable, cellType: UnivNewsTableCell.self)) { _, item, cell in
                cell.setup(item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension NewsViewController {
    private func configureTableView() {
        tableView.register(UnivNewsTableCell.self, forCellReuseIdentifier: UnivNewsTableCell.Reusable)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .black
//        tableView.rowHeight = 120
        tableView.delegate = self
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

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapNewsItem.accept(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
