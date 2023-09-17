//
//  HomeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/24.
//

import UIKit
import WebKit
import RxSwift
import Entity

final class HomeViewController: UIViewController {
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

    private let disposeBag = DisposeBag()
    
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

    // iPadで画面回転を行った際の再描画
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.configureMenuCollectionView()
        })
    }
}

// MARK: Binding
private extension HomeViewController {
    func binding() {
        twitterButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapTwitterButton.accept(())
            }
            .disposed(by: disposeBag)

        githubButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapGithubButton.accept(())
            }
            .disposed(by: disposeBag)

        prBannerPageControl.rx
            .controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.prBannerViewController.showPage(index: self.prBannerPageControl.currentPage, animated: true)
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
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, adItems in
                owner.prBannerViewController.setupContentSize(itemsCount: adItems.count)
                owner.prBannerViewController.addPrBannerPanels(items: adItems)
                owner.prBannerPageControl.numberOfPages = adItems.count
            }
            .disposed(by: disposeBag)

        viewModel.output
            .univItems
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, adItems in
                owner.univBannerViewController.setupContentSize(itemsCount: adItems.count )
                owner.univBannerViewController.addUnivBannerPanels(items: adItems)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .menuDetailItem
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, menuDetailItems in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                menuDetailItems.forEach { item in
                    let action = UIAlertAction(title: item.title, style: .default) { (action) in
                        owner.viewModel.input.didTapMenuDetailItem.accept(item)
                    }
                    alertController.addAction(action)
                }
                let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
                alertController.addAction(cancelAction)

                // iPad用の設定
                alertController.popoverPresentationController?.sourceView = owner.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.size.width/2,
                                                                                   y: UIScreen.main.bounds.size.height-70,
                                                                                   width: 0,
                                                                                   height: 0)

                owner.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .eventPopups
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, popupItems in
            }
            .disposed(by: disposeBag)

        viewModel.output
            .eventButtons
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, buttonItems in
                owner.configureEventButtons(owner: owner, buttonItems: buttonItems)
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
        twitterButton.setImage(R.image.twitter_icon(), for: .normal)
        githubButton.setImage(R.image.github_icon(), for: .normal)
        twitterButton.imageView?.image = UIImage(systemName: "pencil")
        githubButton.imageView?.image = R.image.github_icon()


        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            twitterButton.widthAnchor.constraint(equalToConstant: 100),
            twitterButton.heightAnchor.constraint(equalToConstant: 100),
        ])
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
        menuCollectionView.register(HomeMenuCollectionCell.self, forCellWithReuseIdentifier: HomeMenuCollectionCell.Reusable)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .white
        menuCollectionView.layer.cornerRadius = 20.0
        let layout = UICollectionViewFlowLayout()
        if UIDevice.current.userInterfaceIdiom == .phone {
            // 使用デバイスがiPhoneの場合
            // 画面横に3つ配置したい。余裕を持って横画面/4 に設定
            let cellSize = floor(view.bounds.width / 4)
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
            menuCollectionViewHeightConstraint.constant = (cellSize * 2) + 10

        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // 使用デバイスがiPadの場合
            // 画面横に6つ配置したい。余裕を持って横画面/7 に設定
            let cellSize = floor(view.bounds.width / 7)
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            menuCollectionViewHeightConstraint.constant = cellSize
        }

        menuCollectionView.collectionViewLayout = layout
    }

    func configureEventButtons(owner: HomeViewController?, buttonItems: [HomeEventInfos.ButtonItem]) {
        guard let owner = owner else { return }
        var eventButtons:[UIView] = []
        var maxWidth: CGFloat = 0

        for (index, item) in buttonItems.enumerated() {
            let button = UIButton()
            button.setTitle(item.titleName, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.backgroundColor = R.color.mainColor()
            button.layer.cornerRadius = 20
            button.tag = index
            button.addTarget(owner, action: #selector(owner.buttonTapped(_:)), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 50), // 高さを50に設定
            ])

            // ボタンのサイズをテキストにフィットさせる
            button.sizeToFit()
            // 最大のボタン幅を記録
            if button.frame.width > maxWidth {
                maxWidth = button.frame.width
            }

            eventButtons.append(button)
        }

        let containerView = UIStackView(arrangedSubviews: eventButtons)
        containerView.axis = .vertical
        containerView.distribution = .fill
        containerView.spacing = 12
        containerView.alignment = .fill

        owner.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // ボタンの最大幅に+20を横幅とする
            containerView.widthAnchor.constraint(equalToConstant: maxWidth + 20),
            containerView.trailingAnchor.constraint(equalTo: owner.view.trailingAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: owner.view.bottomAnchor, constant: -100)
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        viewModel.input.didTapEventButton.accept(index)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCollectionCell.Reusable, for: indexPath) as? HomeMenuCollectionCell else {
            return UICollectionViewCell()
        }

        cell.setup(ItemsConstants().menuItems[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didTapMenuCollectionItem.accept(indexPath.row)
    }

    // 中央寄せ
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let cellWidth = Int(flowLayout.itemSize.width)
//        let cellSpacing = Int(flowLayout.minimumInteritemSpacing)
//        let cellCount = ItemsConstants().menuItems.count
//
//        let totalCellWidth = cellWidth * cellCount
//        let totalSpacingWidth = cellSpacing * (cellCount - 1)
//
//        let inset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//
//        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//    }
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
        viewModel.input.didTapMiniSettings.accept(ItemsConstants().homeMiniSettingsItems[indexPath.row])
        homeTableView.deselectRow(at: indexPath, animated: true)
    }
}
