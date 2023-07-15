//
//  HomeContainerViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class HomeContainerViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var univBannerContainerView: UIView!
    @IBOutlet weak var univBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCollectionView: UICollectionView!

    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton

    private let viewModel = HomeViewModel()

    private let menuCollerctionVC = MenuCollectionViewController()

    private var bannerViewController: BannerScrollViewController!
    private var univBannerViewController: BannerScrollViewController!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerViewDefaults()
        setupUnivBannerViewDefaults()
        setupBannerPageControl()
        setupMenuCollectionView()
        setupViewModelStateRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updatePrItems()
    }

    // MARK: - IBAction

    @IBAction func didChangeBannerPageControl() {
        bannerViewController.showPage(index: bannerPageControl.currentPage, animated: true)
    }

    // MARK: - Methods [Private]

    private func setupBannerViewDefaults() {
        bannerViewController = BannerScrollViewController()
        addChild(bannerViewController)
        bannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bannerContainerView.addSubview(bannerViewController.view)
        bannerViewController.view.topAnchor.constraint(equalTo: bannerContainerView.topAnchor).isActive = true
        bannerViewController.view.bottomAnchor.constraint(equalTo: bannerContainerView.bottomAnchor).isActive = true
        bannerViewController.view.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor).isActive = true
        bannerViewController.view.trailingAnchor.constraint(equalTo: bannerContainerView.trailingAnchor).isActive = true
        bannerViewController.didMove(toParent: self)
        bannerViewController.setup()
        bannerContainerViewHeightConstraint.constant = bannerViewController.panelHeight
        bannerViewController.delegate = self
    }

    private func setupUnivBannerViewDefaults() {
        univBannerViewController = BannerScrollViewController()
        addChild(univBannerViewController)
        univBannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        univBannerContainerView.addSubview(univBannerViewController.view)
        univBannerViewController.view.topAnchor.constraint(equalTo: univBannerContainerView.topAnchor).isActive = true
        univBannerViewController.view.bottomAnchor.constraint(equalTo: univBannerContainerView.bottomAnchor).isActive = true
        univBannerViewController.view.leadingAnchor.constraint(equalTo: univBannerContainerView.leadingAnchor).isActive = true
        univBannerViewController.view.trailingAnchor.constraint(equalTo: univBannerContainerView.trailingAnchor).isActive = true
        univBannerViewController.didMove(toParent: self)
        univBannerViewController.setup()
        univBannerContainerViewHeightConstraint.constant = univBannerViewController.panelHeight
        univBannerViewController.delegate = self
    }

    private func setupBannerPageControl() {
        bannerPageControl.pageIndicatorTintColor = .lightGray
        bannerPageControl.currentPageIndicatorTintColor = .black
        bannerPageControl.numberOfPages = dataManager.prItemLists.count
        bannerPageControl.currentPage = bannerViewController.pageIndex
        bannerPageControl.sizeToFit()
    }

    private func setupMenuCollectionView() {
        menuCollectionView.register(R.nib.homeCollectionCell)
        menuCollectionView.delegate = menuCollerctionVC
        menuCollectionView.dataSource = menuCollerctionVC
        menuCollectionView.backgroundColor = .white
        menuCollectionView.cornerRound = 20.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        menuCollectionView.collectionViewLayout = layout
    }

    // ViewModelが変化したことの通知を受けて画面を更新する
    private func setupViewModelStateRecognizer() {
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else { fatalError() }
            DispatchQueue.main.async {
                switch state {
                case .busy:
                    break
                case .ready:
                    self.bannerViewController.setup()
                    self.bannerViewController.addPrBannerPanels()
                    self.univBannerViewController.setup()
                    self.univBannerViewController.addUnivBannerPanels()
                    self.bannerPageControl.numberOfPages = self.dataManager.prItemLists.count
                    break
                case .error:
                    break
                }
            }
        }
    }

    private func updateBannerPageControl() {
        bannerPageControl.currentPage = bannerViewController.pageIndex
    }


}

extension HomeContainerViewController: BannerScrollViewControllerDelegate {

    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
    }
}

class MenuCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let initMenu2Lists:[MenuItemList] = [
        MenuItemList(title: "教務システム", id: .courseManagementHomeMobile, image: R.image.menuIcon.courseManagementHome.name, url: Url.courseManagementMobile.string(), isLockIconExists: true, isHiddon: false),

        MenuItemList(title: "manaba", id: .manabaHomePC, image: R.image.menuIcon.manaba.name, url: Url.manabaPC.string(), isLockIconExists: true, isHiddon: false),

        MenuItemList(title: "メール", id: .mailService, image: R.image.menuIcon.mailService.name, url: Url.outlookService.string(), isLockIconExists: true, isHiddon: false),

        MenuItemList(title: "図書館関連", id: .libraryBookLendingExtension, image: R.image.menuIcon.libraryBookLendingExtension.name, url: Url.libraryBookLendingExtension.string(), isLockIconExists: true, isHiddon: false),

        MenuItemList(title: "生協関連", id: .coopCalendar, image: R.image.menuIcon.coopCalendar.name, url: Url.tokudaiCoop.string(), isLockIconExists: false, isHiddon: false),

        MenuItemList(title: "その他", id: .careerCenter, image: R.image.menuIcon.careerCenter.name, url: Url.tokudaiCareerCenter.string(), isLockIconExists: false, isHiddon: false)
    ]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return initMenu2Lists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
        let collectionList = initMenu2Lists[indexPath.row]
        let title = collectionList.title
        let icon = collectionList.image
        cell.setupCell(title: title, image: icon)
        return cell
    }
}
