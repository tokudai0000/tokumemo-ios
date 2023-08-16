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


final class HomeViewController: BaseViewController {
    @IBOutlet private weak var numberOfUsersLabel: UILabel!
    @IBOutlet private weak var prContainerView: UIView!
    @IBOutlet private weak var prBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var prBannerPageControl: UIPageControl!
    @IBOutlet private weak var univContainerView: UIView!
    @IBOutlet private weak var univBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var menuCollectionView: UICollectionView!
    @IBOutlet private weak var menuCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var homeTableView: UITableView!
    @IBOutlet private weak var homeTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var twitterButton: UIButton!
    @IBOutlet private weak var githubButton: UIButton!

    var viewModel: HomeViewModelInterface!

    private var webView: WKWebView!
    private var prBannerViewController: BannerScrollViewController!
    private var univBannerViewController: BannerScrollViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        configureBanner(for: prContainerView,
                        viewController: prBannerViewController,
                        heightConstraint: prBannerContainerViewHeightConstraint)
        configureBanner(for: univContainerView,
                        viewController: univBannerViewController,
                        heightConstraint: univBannerContainerViewHeightConstraint)
        configurePrBannerPageControl()
        configureMenuCollectionView()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension HomeViewController {
    func binding() {

        bindButtonTapEvent(twitterButton, to: viewModel.input.didTapTwitterButton)
        bindButtonTapEvent(githubButton, to: viewModel.input.didTapGithubButton)

        prBannerPageControl.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.prBannerViewController.showPage(index: self?.prBannerPageControl.currentPage ?? 0, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.output
            .numberOfUsersLabel
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.numberOfUsersLabel.text = text
            }
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

        viewModel.output
            .menuDetailItem
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, menuDetailItems in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                menuDetailItems.forEach { item in
                    let action = UIAlertAction(title: item.title, style: .default) { (action) in
                        self.viewModel.input.didSelectMenuDetailItem.accept(item)
                    }
                    alertController.addAction(action)
                }
                let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension HomeViewController {
    func configureDefaults() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableViewHeightConstraint.constant = CGFloat(44 * ItemsConstants().menuItems.count)
        prBannerViewController = BannerScrollViewController()
        univBannerViewController = BannerScrollViewController()
    }

    private func configureBanner(for containerView: UIView, viewController: BannerScrollViewController, heightConstraint: NSLayoutConstraint) {
        viewController.viewModel = self.viewModel
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        viewController.didMove(toParent: self)
        viewController.initSetup()
        heightConstraint.constant = viewController.panelHeight
        viewController.delegate = self
    }

    func configurePrBannerPageControl() {
        prBannerPageControl.pageIndicatorTintColor = .lightGray
        prBannerPageControl.currentPageIndicatorTintColor = .black
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
        return ItemsConstants().menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
        let title = ItemsConstants().menuItems[indexPath.row].title
        let icon = ItemsConstants().menuItems[indexPath.row].icon
        cell.setupCell(title: title, image: icon)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didTapMenuCollectionItem.accept(indexPath.row)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsConstants().homeMiniSettingsItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeTableView, for: indexPath)!
        cell.textLabel?.text = ItemsConstants().homeMiniSettingsItems[indexPath.item].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectMiniSettings.accept(ItemsConstants().homeMiniSettingsItems[indexPath.row])
        homeTableView.deselectRow(at: indexPath, animated: true)
    }
}
