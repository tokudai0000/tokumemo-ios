//
//  HomeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/24.
//

import UIKit
import WebKit
import RxCocoa
import RxGesture
import RxSwift


final class HomeViewController: UIViewController {
    @IBOutlet private weak var prBannerContainerView: UIView!
    @IBOutlet private weak var prBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var prBannerPageControl: UIPageControl!
    @IBOutlet private weak var univBannerContainerView: UIView!
    @IBOutlet private weak var univBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var menuCollectionView: UICollectionView!
    @IBOutlet private weak var menuCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var homeTableView: UITableView!
    @IBOutlet private weak var homeTableViewHeightConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    var viewModel: HomeViewModelInterface!

    private var webView: WKWebView!
    private var prBannerViewController: BannerScrollViewController!
    private var univBannerViewController: BannerScrollViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureDefaults()
        configurePrBannerDefaults()
        configureUnivBannerDefaults()
        configureMenuCollectionView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.input.viewWillAppear.accept(())
    }

}

// MARK: Binding
private extension HomeViewController {
    func binding() {
        viewModel.output
            .adItems
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, adItems in
                self.prBannerViewController.addPrBannerPanels(items: adItems)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension HomeViewController {
    func configureDefaults() {
//        dataManager.canExecuteJavascript = true
//        homeTableViewHeightConstraint.constant = CGFloat(homeTableViewHight * homeTableItemLists.count)
    }

    /// ログイン用
    func configureWebView() {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(Url.universityTransitionLogin.urlRequest())
    }

    func configurePrBannerDefaults() {
        prBannerViewController = BannerScrollViewController()
        configureBannerViewDefaults(bannerVC: prBannerViewController, containerView: prBannerContainerView)
        prBannerContainerViewHeightConstraint.constant = prBannerViewController.panelHeight
        configurePrBannerPageControl()
    }

    func configureUnivBannerDefaults() {
        univBannerViewController = BannerScrollViewController()
        configureBannerViewDefaults(bannerVC: univBannerViewController, containerView: univBannerContainerView)
        univBannerContainerViewHeightConstraint.constant = univBannerViewController.panelHeight
    }

    func configureBannerViewDefaults(bannerVC: BannerScrollViewController,
                                         containerView: UIView) {
        containerView.addSubview(bannerVC.view)
        bannerVC.initSetup()
        bannerVC.delegate = self
        bannerVC.view.translatesAutoresizingMaskIntoConstraints = false
        bannerVC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bannerVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bannerVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        bannerVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }

    func configurePrBannerPageControl() {
        prBannerPageControl.pageIndicatorTintColor = .lightGray
        prBannerPageControl.currentPageIndicatorTintColor = .black
//        prBannerPageControl.numberOfPages = dataManager.prItemLists.count
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
        prBannerPageControl.sizeToFit()
    }

    func configureMenuCollectionView() {
        menuCollectionView.register(R.nib.homeCollectionCell)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .white
        menuCollectionView.cornerRound = 20.0
        let layout = UICollectionViewFlowLayout()
        let cellWidth = floor(menuCollectionView.bounds.width / 3)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 0,
                                           bottom: 10,
                                           right: 0)
        menuCollectionView.collectionViewLayout = layout
    }
}

extension HomeViewController: BannerScrollViewControllerDelegate {
    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
    }
    func updateBannerPageControl() {
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
    }
}

extension HomeViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeMenuLists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
        let title = homeMenuLists[indexPath.row].title
        let icon = homeMenuLists[indexPath.row].image
        cell.setupCell(title: title, image: icon)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTableItemLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeTableView, for: indexPath)!
        cell.textLabel?.text = homeTableItemLists[indexPath.item].title
        return cell
    }
}

extension HomeViewController: WKUIDelegate, WKNavigationDelegate {
}
