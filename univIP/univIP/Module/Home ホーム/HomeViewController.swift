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
    @IBOutlet private weak var prContainerView: UIView!
    @IBOutlet private weak var prBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var prBannerPageControl: UIPageControl!
    @IBOutlet private weak var univContainerView: UIView!
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
        configurePrBanner()
        configurePrBannerPageControl()
        configureUnivBanner()
        configureMenuCollectionView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension HomeViewController {
    func binding() {
        prBannerPageControl.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.prBannerViewController.showPage(index: self?.prBannerPageControl.currentPage ?? 0, animated: true)
            })
            .disposed(by: disposeBag)


        viewModel.output
            .prItems
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, adItems in
                owner.prBannerViewController.setupContentSize(items: adItems)
                owner.prBannerViewController.addPrBannerPanels(items: adItems)
                owner.prBannerPageControl.numberOfPages = adItems.count
            }
            .disposed(by: disposeBag)

        viewModel.output
            .univItems
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, adItems in
                owner.univBannerViewController.setupContentSize(items: adItems)
                owner.univBannerViewController.addUnivBannerPanels(items: adItems)
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

    func configurePrBanner() {
        prBannerViewController = BannerScrollViewController()
        addChild(prBannerViewController)
        prBannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        prContainerView.addSubview(prBannerViewController.view)
        NSLayoutConstraint.activate([
            prBannerViewController.view.topAnchor.constraint(equalTo: prContainerView.topAnchor),
            prBannerViewController.view.bottomAnchor.constraint(equalTo: prContainerView.bottomAnchor),
            prBannerViewController.view.leadingAnchor.constraint(equalTo: prContainerView.leadingAnchor),
            prBannerViewController.view.trailingAnchor.constraint(equalTo: prContainerView.trailingAnchor),
        ])
        prBannerViewController.didMove(toParent: self)
        prBannerViewController.initSetup()
        prBannerContainerViewHeightConstraint.constant = prBannerViewController.panelHeight
        prBannerViewController.delegate = self
    }

    func configurePrBannerPageControl() {
        prBannerPageControl.pageIndicatorTintColor = .lightGray
        prBannerPageControl.currentPageIndicatorTintColor = .black
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
        prBannerPageControl.sizeToFit()
    }

    func configureUnivBanner() {
        univBannerViewController = BannerScrollViewController()
        univBannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        univContainerView.addSubview(univBannerViewController.view)
        NSLayoutConstraint.activate([
            univBannerViewController.view.topAnchor.constraint(equalTo: univContainerView.topAnchor),
            univBannerViewController.view.bottomAnchor.constraint(equalTo: univContainerView.bottomAnchor),
            univBannerViewController.view.leadingAnchor.constraint(equalTo: univContainerView.leadingAnchor),
            univBannerViewController.view.trailingAnchor.constraint(equalTo: univContainerView.trailingAnchor),
        ])

        univBannerViewController.initSetup()
        univBannerContainerViewHeightConstraint.constant = univBannerViewController.panelHeight
    }



    func configureMenuCollectionView() {
        menuCollectionView.register(R.nib.homeCollectionCell)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .white
        menuCollectionView.cornerRound = 20.0
        let layout = UICollectionViewFlowLayout()
        let cellWidth = floor(menuCollectionView.bounds.width / 3.5)
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
