//
//  HomeContainerViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class HomeContainerViewController: UIViewController {

    let dataManager = DataManager.singleton

    private let viewModel = HomeViewModel()

    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerPageControl: UIPageControl!

    var bannerViewController: BannerScrollViewController!
//    @IBOutlet weak var prImageCollectionView: UICollectionView!
//    let prImageCollerctionVC = PrImageCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerViewDefaults()
        setupBannerPageControl()
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

    private func setupBannerPageControl() {
        bannerPageControl.pageIndicatorTintColor = .lightGray
        bannerPageControl.currentPageIndicatorTintColor = .black
        bannerPageControl.numberOfPages = dataManager.prItemLists.count
        bannerPageControl.currentPage = bannerViewController.pageIndex
        bannerPageControl.sizeToFit()
    }

    private func updateBannerPageControl() {
        bannerPageControl.currentPage = bannerViewController.pageIndex
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
                    self.bannerPageControl.numberOfPages = self.dataManager.prItemLists.count
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

//class PrImageCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return initMenuLists.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
//        let collectionList = initMenuLists[indexPath.row]
//        let title = collectionList.title
//        let icon = collectionList.image
//        cell.setupCell(title: title, image: icon)
//        return cell
//    }
//}
