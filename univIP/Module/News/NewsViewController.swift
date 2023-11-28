//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import RxSwift
import Entity
import Ikemen

class NewsViewController: UIViewController {
    private var tableView = UITableView()
    private var viewActivityIndicator = UIActivityIndicatorView() ※ {
        $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        $0.style = UIActivityIndicatorView.Style.medium
        $0.hidesWhenStopped = true
    }

    private let disposeBag = DisposeBag()

    var viewModel: NewsViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        binding()
        viewModel.input.viewDidLoad.accept(())
        viewActivityIndicator.startAnimating()
    }
}

// MARK: Binding
private extension NewsViewController {
    func binding() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.input.didTapNewsItem.accept(indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output
            .newsItems
            .bind(to: tableView.rx.items(cellIdentifier: UnivNewsTableCell.Reusable, cellType: UnivNewsTableCell.self)) { [weak self] _, item, cell in
                // newsItemsに更新があった = APIの通信が完了した
                self?.viewActivityIndicator.stopAnimating()
                cell.setup(item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension NewsViewController {
    private func configureView() {
        view.backgroundColor = .white

        let autolayout = view.northLayoutFormat([:], [
            "table": tableView,
            "indicator": viewActivityIndicator
        ])
        autolayout("H:|-[table]-|")
        autolayout("V:|-[table]-|")

        NSLayoutConstraint.activate([
            viewActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureTableView() {
        tableView.register(UnivNewsTableCell.self, forCellReuseIdentifier: UnivNewsTableCell.Reusable)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .black
        tableView.delegate = self
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapNewsItem.accept(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
