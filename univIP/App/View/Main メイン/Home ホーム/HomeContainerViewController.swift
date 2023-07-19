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
    @IBOutlet weak var homeTableViewHeightConstraint: NSLayoutConstraint!

    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton

    private let viewModel = HomeViewModel()

    private var prBannerViewController: BannerScrollViewController!
    private var univBannerViewController: BannerScrollViewController!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrBannerDefaults()
        setupUnivBannerDefaults()
        setupMenuCollectionView()
        setupViewModelStateRecognizer()
        homeTableViewHeightConstraint.constant = CGFloat(44 * homeTableItemLists.count)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updatePrItems()
    }

    // MARK: - IBAction

    @IBAction func didChangeBannerPageControl() {
        prBannerViewController.showPage(index: prBannerPageControl.currentPage, animated: true)
    }

    @IBAction func twitterButton(_ sender: Any) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = Url.officialSNS.string()
        present(vc, animated: true)
    }


    // MARK: - Methods [Private]

    private func setupPrBannerDefaults() {
        prBannerViewController = BannerScrollViewController()
        setupBannerViewDefaults(bannerVC: prBannerViewController, containerView: prBannerContainerView)
        prBannerContainerViewHeightConstraint.constant = prBannerViewController.panelHeight
        setupPrBannerPageControl()
    }

    private func setupUnivBannerDefaults() {
        univBannerViewController = BannerScrollViewController()
        setupBannerViewDefaults(bannerVC: univBannerViewController, containerView: univBannerContainerView)
        univBannerContainerViewHeightConstraint.constant = univBannerViewController.panelHeight
    }

    private func setupBannerViewDefaults(bannerVC: BannerScrollViewController,
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

    private func updateBannerPageControl() {
        prBannerPageControl.currentPage = prBannerViewController.pageIndex
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
                    self.prBannerViewController.setupContentSize()
                    self.prBannerViewController.addPrBannerPanels()
                    self.prBannerPageControl.numberOfPages = self.dataManager.prItemLists.count

                    self.univBannerViewController.setupContentSize()
                    self.univBannerContainerViewHeightConstraint.constant = self.univBannerViewController.panelHeight
                    self.univBannerViewController.addUnivBannerPanels()
                    break
                case .error:
                    break
                }
            }
        }
    }
}

extension HomeContainerViewController: BannerScrollViewControllerDelegate {

    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = homeMenuLists[indexPath.row]
        if let url = cell.url {
            let vc = R.storyboard.web.webViewController()!
            vc.loadUrlString = url
            present(vc, animated: true, completion: nil)
        }
//        switch cell.id {
//        case .libraryRAS:
//
//        case .coopRAS:
//
//        case .etc:
//
//        default:
//            break
//        }
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = cell.url
        present(vc, animated: true, completion: nil)
    }
}

extension HomeContainerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeTableItemLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeTableView, for: indexPath)!
        cell.textLabel?.text = homeTableItemLists[indexPath.item].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = homeTableItemLists[indexPath.row]
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = cell.url!
        present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 44
     }
}
