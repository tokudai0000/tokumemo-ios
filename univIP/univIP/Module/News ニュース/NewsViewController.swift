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
    private typealias Section = NewsListSectionModel
    private typealias Item = NewsListItemModel
    private class DataSource: UITableViewDiffableDataSource<Section, Item> {}

    @IBOutlet weak var tableView: UITableView!

    var viewModel: NewsViewModelInterface!

    private let disposeBag = DisposeBag()
    
    private var viewActivityIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupDefaults()
//        setupIndicatorView()
        tableView.register(R.nib.newsTableViewCell)
        binding()
        viewModel.input.viewDidLoad.accept(())
//        setupViewModelStateRecognizer()

//        data.bind(to: tableView.rx.items(cellIdentifier: "NewsCell")) { index, model, cell in
//            cell.textLabel?.text = model
//            }
//            .disposed(by: disposeBag)

        // セルの登録
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
    }
}

// MARK: Binding
private extension NewsViewController {
    func binding() {
        viewModel.output
            .sectionItems
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, sectionItems in
                var snapShot = owner.dataSource.snapshot()
                snapShot.deleteAllItems()
                snapShot.appendSections(sectionItems)
                sectionItems.forEach { section in
                    snapShot.appendItems(section.items, toSection: section)
                }
                owner.dataSource.apply(snapShot, animatingDifferences: false)
//                tableView(tableView, numberOfRowsInSection: newsItems.count)
//                self.univBannerViewController.addUnivBannerPanels(items: adItems)
            }
            .disposed(by: disposeBag)



        viewModel.output.newsItems
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.newsTableViewCell.identifier, cellType: NewsTableViewCell.self)) { index, model, cell in
//            .bind(to: tableView.rx.items(nibName: ))
//            .bind(to: tableView.rx.items(nibName: R.nib.newsTableViewCell.name, cellIdentifier: R.reuseIdentifier.newsTableViewCell.identifier, cellType: NewsTableViewCell.self)) { index, model, cell in
//            .bind(to: tableView.rx.items(cellIdentifier: "NewsCell", cellType: UITableViewCell.self)) { index, model, cell in
//                cell.textLabel?.text = model.title // modelはNewsItem型のインスタンスを想定

                cell.setupCell(text: model.title, date: "xxx")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension NewsViewController {
    private func setupDefaults() {
//        tableView.register(R.nib.newsTableViewCell)
//        viewModel.updateNewsItems()
    }

//    private func configureTableView() {
////        tableView.register(HomeListHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeListHeaderView.reuseIdentifier)
//        tableView.register(R.nib.newsTableViewCell)
//        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, item in
//            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.newsTableViewCell, for: indexPath)!
////            cell.configure(model: item)
//            cell.selectionStyle = .none
//            cell.separatorInset = .zero
//            return cell
//        })
//
//        tableView.delegate = self
//        tableView.dataSource = dataSource
//        tableView.backgroundColor = AppConstants.Color.backGroundGray
//        tableView.showsVerticalScrollIndicator = true
//        tableView.indicatorStyle = .black
//    }

    private func setupIndicatorView() {
        viewActivityIndicator = UIActivityIndicatorView()
        viewActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        viewActivityIndicator.center = self.view.center
        viewActivityIndicator.hidesWhenStopped = true
        viewActivityIndicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(viewActivityIndicator)
    }
    
    // ViewModelが変化したことの通知を受けて画面を更新する
//    private func setupViewModelStateRecognizer() {
//        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
//        self.viewModel.state = { [weak self] (state) in
//            guard let self = self else {
//                fatalError()
//            }
//            DispatchQueue.main.async {
//                switch state {
//                case .busy: // 通信中
//                    self.viewActivityIndicator.startAnimating() // クルクルスタート
//                    break
//
//                case .ready: // 通信完了
//                    self.viewActivityIndicator.stopAnimating() // クルクルストップ
//                    self.tableView.reloadData()
//                    break
//
//                case .error:
//                    break
//                }
//            }
//        }
//    }
}


//extension NewsViewController: UITableViewDelegate {
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(80)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        viewModel.input.didTapNewsItem.accept(item)
//    }
//}
