//
//  HomeContainerViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class HomeContainerViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var prBannerContainerView: UIView!
    @IBOutlet weak var prBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var prBannerPageControl: UIPageControl!
    @IBOutlet weak var univBannerContainerView: UIView!
    @IBOutlet weak var univBannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var menuCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!

    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton

    private let viewModel = HomeViewModel()

    private var prBannerViewController: BannerScrollViewController!
    private var univBannerViewController: BannerScrollViewController!

    enum SettingItemType {

        case password

        /// お気に入り登録
        case favorite

        /// 並び替え機能
        case customize

        case aboutThisApp

        case contactUs

        /// トクメモ＋のTwitter
        case officialSNS

        /// トクメモ＋のLit.linkホームページ
        case homePage

        case termsOfService

        case privacyPolicy

        /// univIPのGitHub
        case sourceCode
    }

    struct SettingItem {
        let title: String
        let id: SettingItemType
        let url: String?
    }

    let settingItemLists = [
        [SettingItem(title: "パスワード設定", id: .password, url: nil)],

        [SettingItem(title: "お気に入り登録", id: .favorite, url: nil),
         SettingItem(title: "カスタマイズ", id: .customize, url: nil)],

        [SettingItem(title: "このアプリについて", id: .aboutThisApp, url: Url.appIntroduction.string()),
         SettingItem(title: "お問い合わせ", id: .contactUs, url: Url.contactUs.string()),
         SettingItem(title: "公式SNS", id: .officialSNS, url: Url.officialSNS.string()),
         SettingItem(title: "ホームページ", id: .homePage, url: Url.homePage.string()),],

        [SettingItem(title: "利用規約", id: .termsOfService, url: Url.termsOfService.string()),
         SettingItem(title: "プライバシーポリシー", id: .privacyPolicy, url: Url.privacyPolicy.string()),
         SettingItem(title: "ソースコード", id: .sourceCode,url: Url.sourceCode.string())]]

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prBannerViewController = BannerScrollViewController()
        setupBannerViewDefaults(prBannerViewController, prBannerContainerView, prBannerContainerViewHeightConstraint)
        setupPrBannerPageControl()
        univBannerViewController = BannerScrollViewController()
        setupBannerViewDefaults(univBannerViewController, univBannerContainerView, univBannerContainerViewHeightConstraint)
        setupMenuCollectionView()
        setupViewModelStateRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updatePrItems()
    }

    // MARK: - IBAction

    @IBAction func didChangeBannerPageControl() {
        prBannerViewController.showPage(index: prBannerPageControl.currentPage, animated: true)
    }

    // MARK: - Methods [Private]

    private func setupBannerViewDefaults(_ bannerViewController: BannerScrollViewController,
                                         _ bannerContainerView: UIView,
                                         _ bannerContainerViewHeightConstraint: NSLayoutConstraint) {
        addChild(bannerViewController)
        bannerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bannerContainerView.addSubview(bannerViewController.view)
        bannerViewController.view.topAnchor.constraint(equalTo: bannerContainerView.topAnchor).isActive = true
        bannerViewController.view.bottomAnchor.constraint(equalTo: bannerContainerView.bottomAnchor).isActive = true
        bannerViewController.view.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor).isActive = true
        bannerViewController.view.trailingAnchor.constraint(equalTo: bannerContainerView.trailingAnchor).isActive = true
        bannerViewController.didMove(toParent: self)
        bannerViewController.setup()
        bannerViewController.delegate = self
        bannerContainerViewHeightConstraint.constant = bannerViewController.panelHeight
    }

    private func setupPrBannerPageControl() {
        prBannerPageControl.pageIndicatorTintColor = .lightGray
        prBannerPageControl.currentPageIndicatorTintColor = .black
        prBannerPageControl.numberOfPages = dataManager.prItemLists.count
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
        prBannerPageControl.sizeToFit()
    }

    private func setupMenuCollectionView() {
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

    // ViewModelが変化したことの通知を受けて画面を更新する
    private func setupViewModelStateRecognizer() {
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else { fatalError() }
            DispatchQueue.main.async {
                switch state {
                case .busy:
                    break
                case .ready:
                    self.prBannerViewController.setup()
                    self.prBannerViewController.addPrBannerPanels()
                    self.prBannerPageControl.numberOfPages = self.dataManager.prItemLists.count
                    self.univBannerViewController.setup()
                    self.univBannerViewController.addUnivBannerPanels()
                    break
                case .error:
                    break
                }
            }
        }
    }

    private func updateBannerPageControl() {
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
    }
}

extension HomeContainerViewController: BannerScrollViewControllerDelegate {

    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
    }
}

extension HomeContainerViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingItemLists.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItemLists[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeTableView, for: indexPath)!
        cell.textLabel?.text = settingItemLists[indexPath.section][indexPath.item].title
        return cell
    }


}

extension HomeContainerViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // セルの割当に利用可能なwidth
        let availableWidth = menuCollectionView.bounds.width
        let margin: CGFloat = 10
        let itemPerWidth: CGFloat = 3
        // セル一つのwidth
        // : ( menuCollectionViewの横サイズ / 1列当たりのアイテム数 ) - 余白
        let cellWidth = (availableWidth / itemPerWidth) - margin
        // menuCollectionViewの縦サイズを指定
        // : ( セルサイズ + 余白 ) * 2
        menuCollectionViewHeightConstraint.constant = (cellWidth + margin) * 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
