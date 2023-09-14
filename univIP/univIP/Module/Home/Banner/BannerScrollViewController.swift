//
//  BannerScrollViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit
import Entity

protocol BannerScrollViewControllerDelegate: AnyObject {
    /// pageIndexが変わったときに呼ばれる
    func bannerScrollViewController(_ scrollViewController: BannerScrollViewController, didChangePageIndex index: Int)
}

/// バナー表示Viewのコントローラ
/// scrollViewを使って表示している
class BannerScrollViewController: UIViewController {
    /// バナーエリアの全体の幅
    let baseComponentWidth: CGFloat = 406
    /// デザインでのパネルの幅
    let basePanelWidth: CGFloat = 355
    /// デザインでのパネルの高さ
    let basePanelImageHeight: CGFloat = 238
    /// デザインでのテキスト部分の高さ
    let basePanelTextContainerHeight: CGFloat = 30
    /// デザインでのパネルの横マージン（先頭の左マージン）
    lazy var basePanelHorizontalMargin: CGFloat = (baseComponentWidth - basePanelWidth) / 2
    /// デザインでのパネル間のマージン
    let basePanelGap: CGFloat = 8
    /// パネルの幅
    private(set) var panelWidth: CGFloat = 0
    /// パネルの高さ
    private(set) var panelHeight: CGFloat = 0
    /// パネルの横マージン（先頭の左マージン）
    private(set) var panelHorizontalMargin: CGFloat = 0
    /// パネル間のマージン
    private(set) var panelGap: CGFloat = 0

    private(set) var scrollView: UIScrollView!

    private(set) var contentView: UIView!
    private var contentViewWidthConstraint: NSLayoutConstraint!

    /// 現在のPageIndex
    private(set) var pageIndex: Int = 0

    var delegate: BannerScrollViewControllerDelegate?

    var viewModel: HomeViewModelInterface!

    /// 初期化
    func initSetup() {
        setupViewSizes()
        setupScrollView()
        setupContentSize(itemsCount: 0)
    }

    func setupViews() {
        if let contents = contentView{
            for subview in contents.subviews {
                subview.removeFromSuperview()
            }
        }
    }

    /// viewの大きさ測定
    func setupViewSizes() {
        let viewWidth = view.frame.width
        var ratio: CGFloat = viewWidth / baseComponentWidth
        // baseComponentWidthより大きいディスプレイの場合は、baseComponentWidthに合わせる
        if 1.0 <= ratio {
            ratio = 1.0
        }
        panelWidth = ratio * basePanelWidth
        panelHeight = ratio * basePanelImageHeight + basePanelTextContainerHeight
        panelHorizontalMargin = ratio * basePanelHorizontalMargin
        panelGap = ratio * basePanelGap
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView = UIView()
        scrollView.addSubview(contentView)
        // 本来見えない箇所をclipsToBounds=falseで見えるようにしている。
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true

        // 横幅はパネルの幅+パネル間のマージン
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: panelHorizontalMargin).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: (panelHorizontalMargin - panelGap)).isActive = true
        // frameの外はタッチイベントがきかない。その回避策
        // https://stackoverflow.com/a/36641652
        view.addGestureRecognizer(scrollView.panGestureRecognizer)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        contentViewWidthConstraint.isActive = true
        contentView.heightAnchor.constraint(equalToConstant: panelHeight).isActive = true
    }

    func setupContentSize(itemsCount: Int) {
        let count = CGFloat(itemsCount)
        let contentWidth = (panelWidth + panelGap) * (count)
        contentViewWidthConstraint.constant = contentWidth
        scrollView.contentSize = CGSize(width: contentWidth, height: panelHeight)
    }

    /// パネル追加
    func addPrBannerPanels(items: [AdItem]) {
        var prevBannerView: PrBannerView?
        items.enumerated().forEach { index, item in

            let bannerView = R.nib.prBannerView(withOwner: self)!

            if let url = URL(string: item.imageUrlStr) {
                bannerView.imageView.loadImage(from: url)
                bannerView.imageView.contentMode = .scaleAspectFill
            }

            // レイアウト
            bannerView.backgroundColor = .clear
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(bannerView)
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            if index == 0 {
                bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            } else {
                if let prevBanner = prevBannerView {
                    bannerView.leadingAnchor.constraint(equalTo: prevBanner.trailingAnchor, constant: panelGap).isActive = true
                }
            }
            bannerView.widthAnchor.constraint(equalToConstant: panelWidth).isActive = true
            bannerView.imageView.layer.cornerRadius = 20
            prevBannerView = bannerView

            // バナーをタップしたときのイベント設定
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPrBanner(gesture:)))
            gesture.numberOfTouchesRequired = 1
            bannerView.tag = index
            bannerView.addGestureRecognizer(gesture)
        }

        contentView.layoutSubviews()
    }

    func addUnivBannerPanels(items: [AdItem]) {
        var prevBannerView: UnivBannerView?
        items.enumerated().forEach { index, item in

            let bannerView = R.nib.univBannerView(withOwner: self)!
            if let url = URL(string: item.imageUrlStr) {
                bannerView.imageView.loadImage(from: url)
                bannerView.imageView.contentMode = .scaleAspectFill
            }
            bannerView.titleTextView.text = item.clientName
            bannerView.discriptionTextView.text = item.imageDescription

            // レイアウト
            bannerView.backgroundColor = .clear
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(bannerView)
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            if index == 0 {
                bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            } else {
                if let prevBanner = prevBannerView {
                    bannerView.leadingAnchor.constraint(equalTo: prevBanner.trailingAnchor, constant: panelGap).isActive = true
                }
            }
            bannerView.widthAnchor.constraint(equalToConstant: panelWidth).isActive = true
            bannerView.imageView.layer.cornerRadius = 20
            prevBannerView = bannerView

            // バナーをタップしたときのイベント設定
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUnivBanner(gesture:)))
            gesture.numberOfTouchesRequired = 1
            bannerView.tag = index
            bannerView.addGestureRecognizer(gesture)
        }
        contentView.layoutSubviews()
    }
    
    @objc func didTapPrBanner(gesture: UITapGestureRecognizer) {
        if case .ended = gesture.state,
           let index = gesture.view?.tag {
            viewModel.input.didTapPrItem.accept(index)
        }
    }

    @objc func didTapUnivBanner(gesture: UITapGestureRecognizer) {
        if case .ended = gesture.state,
           let index = gesture.view?.tag {
            viewModel.input.didTapUnivItem.accept(index)
        }
    }

    /// 現在のページindexを返す
    func calcPageIndex(contentOffsetX: CGFloat) -> Int {
        // 0.5 - 1.5 の間は1で返す
        // 1.5 - 2.5 の間は2で返す....
        return Int(round(contentOffsetX / (panelWidth + panelGap)))
    }

    /// ページを表示する
    func showPage(index: Int, animated: Bool) {
        let offset = CGPoint(
            x: CGFloat(index) * (panelWidth + panelGap),
            y: 0
        )
        scrollView.setContentOffset(offset, animated: animated)
    }
}

extension BannerScrollViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = pageIndex
        let newIndex = calcPageIndex(contentOffsetX: scrollView.contentOffset.x)
        if currentIndex != newIndex {
            pageIndex = newIndex
            delegate?.bannerScrollViewController(self, didChangePageIndex: newIndex)
        }
    }
}
