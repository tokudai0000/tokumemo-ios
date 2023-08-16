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

class NewsViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!

    //    private var viewActivityIndicator: UIActivityIndicatorView!

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
        viewModel.output.newsItems
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.newsTableViewCell.identifier, cellType: NewsTableViewCell.self)) { index, model, cell in
                cell.configure(model: model)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.input.didTapNewsItem.accept(indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension NewsViewController {
    private func configureTableView() {
        tableView.register(R.nib.newsTableViewCell)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .black
        tableView.rowHeight = 120
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
