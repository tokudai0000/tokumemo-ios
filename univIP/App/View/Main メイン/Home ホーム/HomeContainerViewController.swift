//
//  HomeContainerViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class HomeContainerViewController: UIViewController {

    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerContainerViewHeightConstraint: NSLayoutConstraint!
    var bannerViewController: BannerScrollViewController!

    @IBOutlet weak var bannerPageControl: UIPageControl!

//    @IBOutlet weak var prImageCollectionView: UICollectionView!
//    let prImageCollerctionVC = PrImageCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
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

        setupBannerPageControl()
//        prImageCollectionView.register(R.nib.homeCollectionCell)
//
//        prImageCollectionView.delegate = prImageCollerctionVC
//        prImageCollectionView.dataSource = prImageCollerctionVC
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
//        prImageCollectionView.collectionViewLayout = layout
    }

    func setupBannerPageControl() {
        bannerPageControl.pageIndicatorTintColor = .lightGray
        bannerPageControl.currentPageIndicatorTintColor = .black
        bannerPageControl.numberOfPages = bannerViewController.colors.count
        bannerPageControl.currentPage = bannerViewController.pageIndex
        bannerPageControl.sizeToFit()
    }

    func updateBannerPageControl() {
        bannerPageControl.currentPage = bannerViewController.pageIndex
    }

    @IBAction func didChangeBannerPageControl() {
        bannerViewController.showPage(index: bannerPageControl.currentPage, animated: true)
    }
}
extension HomeContainerViewController: BannerScrollViewControllerDelegate {

    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int) {
        updateBannerPageControl()
    }
}

extension UIColor {

    /// https://stackoverflow.com/a/27203691
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
