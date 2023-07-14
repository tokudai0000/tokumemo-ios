//
//  HomeContainerViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class HomeContainerViewController: UIViewController {

    @IBOutlet weak var prImageCollectionView: UICollectionView!
    let prImageCollerctionVC = PrImageCollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        prImageCollectionView.register(R.nib.homeCollectionCell)

        prImageCollectionView.delegate = prImageCollerctionVC
        prImageCollectionView.dataSource = prImageCollerctionVC
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        prImageCollectionView.collectionViewLayout = layout
    }

}

class PrImageCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return initMenuLists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)!
        let collectionList = initMenuLists[indexPath.row]
        let title = collectionList.title
        let icon = collectionList.image
        cell.setupCell(title: title, image: icon)
        return cell
    }
}

//extension HomeContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
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
//
//
//}
