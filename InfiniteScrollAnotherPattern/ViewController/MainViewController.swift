//
//  MainViewController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/07/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: 元記事＆元リポジトリを参考に無限すスクロールを実装する
// ← 元記事: https://qiita.com/HirotoshiKawauchi/items/92bccea0fcd4468e59a0
// ← 元リポジトリ: https://github.com/HirotoshiKawauchi/InfinitePaging

final class MainViewController: UIViewController {

    // MEMO: InterfaceBuilder上における設定のポイント
    //

    // MARK: - Properties

    // MEMO:
    @IBOutlet private weak var carouselScrollView: CarouselScrollView!
    @IBOutlet private weak var selectionCarouselScrollView: CarouselScrollView!

    // MEMO:
    @IBOutlet private weak var paginateScrollView: UIScrollView!

    private var carouselContentsViews: [CarouselContentsView] = []

    private var centerTabIndex: Int = 0

    private weak var selectionMaskLayer: CAShapeLayer!
    private let selectionMaskCornerRadius: CGFloat = 40.0

    // MARK: - Enum

    enum DisplayPosition: Int {

        // MEMO: コンテンツ表示部分のスクロール位置のEnum定義
        case left
        case center
        case right

        // MEMO: スクロール時に表示内容を入れ替えるために利用する
        func inverse() -> DisplayPosition {
            switch self {
            case .left:
                return .right
            case .center:
                return .center
            case .right:
                return .left
            }
        }
    }

    // MARK: - Computed Property

    var selectedCarouselContentsView: CarouselContentsView? {
        return viewAt(position: .center)
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutIfNeeded()
        setupScrollViews()
        setupSelectionMask()
        setupCarouselContents()
    }

    // MARK: - Private Function

    // ※1: 画面の初期設定に関する設定

    private func setupScrollViews() {

        //
        carouselScrollView.delegate = self
        carouselScrollView.showsHorizontalScrollIndicator = false

        //
        selectionCarouselScrollView.delegate = self
        selectionCarouselScrollView.showsHorizontalScrollIndicator = false
        selectionCarouselScrollView.isUserInteractionEnabled = false
        selectionCarouselScrollView.delaysContentTouches = false

        //
        paginateScrollView.delegate = self
        paginateScrollView.showsHorizontalScrollIndicator = false
    }

    private func setupCarouselContents() {
        let titles: [String] = ["モルモラット", "ブルホーン", "タイグリス", "ラビーナ",
                                "ドランシア", "ヴァイパー", "サラブレード", "ラム",
                                "ハマーコング", "クックル", "ライカ", "ワイルドボウ"]
        let contentKeys: [String] = ["A", "B", "C", "D",
                                     "E", "F", "G", "H",
                                     "I", "J", "K", "L"]
        
        var contents: [String : String] = [:]
        for (index, key) in contentKeys.enumerated() {
            contents[key] = titles[index]
        }
        
        for content in contents {
            let contentView = CarouselContentsView()
            contentView.frame = view.bounds
            contentView.setContents(title: content.value, contentKey: content.key)
            carouselContentsViews.append(contentView)
        }
        
        selectedView(view: carouselContentsViews.first!, animated: true)
        
        carouselScrollView.setupCarousel(contentsViewList: carouselContentsViews)
        selectionCarouselScrollView.setupCarousel(contentsViewList: carouselContentsViews, isSelection: true)
        paginateScrollView.contentOffset.x = UIScreen.main.bounds.width
        
        refreshSelectionMask()
        scrollToHorizontalCenter(index: carouselContentsViews.count)
    }

    func viewAt(position: DisplayPosition) -> CarouselContentsView? {
        var view: UIView?
        if position.rawValue < paginateScrollView.subviews.count {
            view = paginateScrollView.subviews[position.rawValue].subviews.last
        }
        
        if let view = view {
            for carouselContentsView in carouselContentsViews {
                if carouselContentsView === view {
                    return carouselContentsView
                }
            }
        }
        return nil
    }
    
    func setCarouselContentsView(view: CarouselContentsView, at position: DisplayPosition, newIndex: Int? = nil) {
        if let currentcarouselContentsView = viewAt(position: position),
            let selectedView = viewAt(position: .center),
            let currentIndex = carouselContentsViews.firstIndex(of: currentcarouselContentsView) {
            
            let index = newIndex ?? carouselContentsViews.firstIndex(of: position == .center ? view : selectedView)!
            let minIndex = min(currentIndex, index)
            let maxIndex = max(currentIndex, index)
            if min(abs(minIndex - maxIndex), abs(minIndex + carouselContentsViews.count - maxIndex) as Int) > 1 {
                currentcarouselContentsView.removeFromSuperview()
            }
        }
        
        paginateScrollView.subviews[position.rawValue].addSubview(view)
    }
    
    func selectedView(view: CarouselContentsView, animated: Bool) {
        guard let index = carouselContentsViews.firstIndex(of: view) else {
            return
        }
        
        setCarouselContentsView(view: view, at: .center)
        setCarouselContentsView(view: carouselContentsViews[(index - 1 + carouselContentsViews.count) % carouselContentsViews.count], at: .left)
        setCarouselContentsView(view: carouselContentsViews[(index + 1) % carouselContentsViews.count], at: .right)
    }
    
    func resetContentViewsPosition(centerIndex: Int) {
        guard centerIndex < carouselContentsViews.count else {
                return
        }
        
        selectedView(view: carouselContentsViews[centerIndex], animated: false)
    }
    
    func removeViewAt(position: DisplayPosition) {
        guard let view = viewAt(position: position) else {
            return
        }
        
        view.removeFromSuperview()
    }
    

    

    func setupSelectionMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame.size.height = selectionCarouselScrollView.bounds.height
        let path: CGPath = UIBezierPath(roundedRect: maskLayer.bounds, cornerRadius: selectionMaskCornerRadius).cgPath
        maskLayer.path = path
        selectionCarouselScrollView.layer.mask = maskLayer
        selectionMaskLayer = maskLayer
    }
    
    func refreshSelectionMask() {
        
        let isTabMoving: Bool = paginateScrollView.contentOffset.x == paginateScrollView.bounds.width
        
        guard let selectedView = selectedCarouselContentsView,
              let selectedIndex = carouselContentsViews.firstIndex(of: selectedView),
            let nextView = viewAt(position: isTabMoving ? .center : paginateScrollView.contentOffset.x < paginateScrollView.bounds.width ? .left : .right),
            let nextIndex = carouselContentsViews.firstIndex(of: nextView) else {
                return
        }
        
        if isTabMoving,
            let sortedNearerCenterTab = sortedNearerCenterTab,
            sortedNearerCenterTab.count >= 2 {
            let centerTab = sortedNearerCenterTab[0]
            let nextTab = sortedNearerCenterTab[1]
            let percent = abs(carouselScrollView.visibleFrame.midX - centerTab.frame.midX) / abs(centerTab.frame.midX - nextTab.frame.midX)
            updateSelectionMaskLayer(withPersent: percent, centerTabView: centerTab, nextTabView: nextTab)
            return
        }
        
        let percent = abs(paginateScrollView.contentOffset.x - paginateScrollView.bounds.width) / paginateScrollView.bounds.width
        let tabViews = carouselScrollView.carouselTitleViews
        let selectedTab = tabViews[selectedIndex]
        let nextTab = tabViews[nextIndex]
        
        updateSelectionMaskLayer(withPersent: percent, centerTabView: selectedTab, nextTabView: nextTab)
    }
    
    private func updateSelectionMaskLayer(withPersent percent: CGFloat, centerTabView centerTab: CarouselTitleView, nextTabView nextTab: CarouselTitleView) {
        let width = centerTab.bounds.width * (1 - percent) + nextTab.bounds.width * percent
        let tabY = floor((carouselScrollView.frame.height - (centerTab.bounds.height - 10)) / 2)
        let roundRect = CGRect(x: carouselScrollView.visibleFrame.midX - (width / 2),
                               y: tabY,
                               width: width,
                               height: centerTab.bounds.height - 10)
        selectionMaskLayer.path = UIBezierPath(roundedRect: roundRect, cornerRadius: selectionMaskCornerRadius).cgPath
    }
    

    func scrollToHorizontalCenter(index: Int, animated: Bool = false) {
        let centeringTab = carouselScrollView.carouselTitleViews[index]
        var centeringTabOffset = carouselScrollView.visibleFrame.minX - (carouselScrollView.visibleFrame.midX - centeringTab.frame.midX)
        
        centerTabIndex = index
        if centeringTabOffset < 0.0 {
            carouselScrollView.contentOffset.x += carouselScrollView.allCarouselWidth
            centeringTabOffset += carouselScrollView.allCarouselWidth
            centerTabIndex += carouselContentsViews.count
            refreshSelectedMaskFixerdToCenter()
        } else if centeringTabOffset > carouselScrollView.allCarouselWidth * 2.0 {
            carouselScrollView.contentOffset.x -= carouselScrollView.allCarouselWidth
            centerTabIndex -= carouselContentsViews.count
            refreshSelectedMaskFixerdToCenter()
        }
        
        carouselScrollView.setContentOffset(CGPoint(x: centeringTabOffset, y: carouselScrollView.contentOffset.y), animated: animated)
    }
    
    func refreshSelectedMaskFixerdToCenter() {
        let tabViews = carouselScrollView.carouselTitleViews
        let centerTab = tabViews[centerTabIndex]
        let tabY = floor((carouselScrollView.frame.height - centerTab.bounds.height - 10) / 2)
        let roundRect = CGRect(x: carouselScrollView.visibleFrame.midX - (centerTab.bounds.height / 2),
                               y: tabY,
                               width: centerTab.bounds.width,
                               height: centerTab.bounds.height / 2)
        selectionMaskLayer.path = UIBezierPath(roundedRect: roundRect, cornerRadius: selectionMaskCornerRadius).cgPath
    }
    
    func trackingTabScrollView() {
        let position: DisplayPosition = paginateScrollView.contentOffset.x < paginateScrollView.bounds.width ? .left : .right
        guard let selectedView = selectedCarouselContentsView,
              let selectedTab = findMostCenterTabIndexForTitle(title: selectedView.carouselTitle ?? ""),
            let nextView = viewAt(position: position),
            let nextTab = findMostCenterTabIndexForTitle(title: nextView.carouselTitle ?? "") else {
                return
        }
        
        let tabCenterInterval = selectedTab.bounds.midX + nextTab.bounds.midX
        let percent: CGFloat = ((abs(paginateScrollView.contentOffset.x - paginateScrollView.bounds.width)) / paginateScrollView.bounds.width)
        let moveValueRight = nextTab.frame.midX - (carouselScrollView.visibleFrame.midX + (tabCenterInterval * (1.0 - percent)))
        let moveValueLeft = (carouselScrollView.visibleFrame.midX - (tabCenterInterval * (1.0 - percent))) - nextTab.frame.midX
        if position == .left {
            carouselScrollView.contentOffset.x -= moveValueLeft
        } else {
            carouselScrollView.contentOffset.x += moveValueRight
        }
    }
    
    
    var sortedNearerCenterTab: [CarouselTitleView]? {
        let tabs = carouselScrollView.carouselTitleViews
        if tabs.isEmpty {
            return nil
        }
        
        return tabs.sorted(by: { (tab1, tab2) -> Bool in
            abs(carouselScrollView.visibleFrame.midX - tab1.frame.midX) < abs(carouselScrollView.visibleFrame.midX - tab2.frame.midX)
        })
    }
    
    func findMostCenterTabIndexForTitle(title: String) -> CarouselTitleView? {
        return sortedNearerCenterTab?.filter({ $0.titleLabel.text == title }).first
    }
}


extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === paginateScrollView {
            guard scrollView.contentSize != .zero else {
                return
            }
            
            trackingTabScrollView()
            
            // faking infinite scrolling
            recenterPagingScrollView()
        } else if scrollView === carouselScrollView {
            if scrollView.contentOffset.x < 0.0 {
                carouselScrollView.contentOffset.x = carouselScrollView.allCarouselWidth
                centerTabIndex = (centerTabIndex % carouselContentsViews.count) + carouselContentsViews.count
            } else if scrollView.contentOffset.x > carouselScrollView.allCarouselWidth * 2.0 {
                carouselScrollView.contentOffset.x = carouselScrollView.allCarouselWidth
                centerTabIndex = (centerTabIndex % carouselContentsViews.count) + carouselContentsViews.count
            }
        }
        
        selectionCarouselScrollView.contentOffset = carouselScrollView.contentOffset
        refreshSelectionMask()
    }
    
    private func recenterPagingScrollView() {
        var position = DisplayPosition.center
        if paginateScrollView.contentOffset.x <= 0 {
            position = .left
        } else if paginateScrollView.contentOffset.x >= 2 * paginateScrollView.bounds.width {
            position = .right
        }
        
        guard position != .center else {
            return
        }
        
        guard let view = viewAt(position: position) else {
            return
        }
        
        removeViewAt(position: position.inverse())
        selectedView(view: view, animated: true)
        paginateScrollView.contentOffset.x += (position == .left ? 1 : -1) * paginateScrollView.bounds.width
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === carouselScrollView,
            !decelerate else {
            return
        }
        
        moveToMostCenterTab()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === carouselScrollView else {
            return
        }
        
        moveToMostCenterTab()
    }
    
    private func contentIndex(forContentKey key: String) -> Int? {
        for (index, contentView) in carouselContentsViews.enumerated() {
            if contentView.contentKey == key {
                return index
            }
        }
        
        return nil
    }
    
    private func moveToMostCenterTab() {
        guard let mostCenterTab = sortedNearerCenterTab?.first,
            let contentIndex = contentIndex(forContentKey: mostCenterTab.contentKey),
            let centerIndex = carouselScrollView.carouselTitleViews.firstIndex(of: mostCenterTab) else {
                return
        }
        
        resetContentViewsPosition(centerIndex: contentIndex)
        scrollToHorizontalCenter(index: centerIndex, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView === paginateScrollView {
            let roundedValue = round(scrollView.contentOffset.x / scrollView.bounds.width) * scrollView.bounds.width
            if scrollView.contentOffset.x != roundedValue {
                scrollView.contentOffset.x = round(scrollView.contentOffset.x / scrollView.bounds.width) * scrollView.bounds.width
            }
        }
    }
}
