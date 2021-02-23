//
//  MainViewController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/07/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: 元記事＆元リポジトリを参考に無限すスクロールを実装する
// 参考1
// 元記事: https://qiita.com/MoeTakeuchi0401/items/d2a75c6d3db59e5673f5
// 元リポジトリ: https://github.com/MoeTakeuchi0401/LoopPageDemo
// 参考2
// 元記事: https://qiita.com/HirotoshiKawauchi/items/92bccea0fcd4468e59a0
// 元リポジトリ: https://github.com/HirotoshiKawauchi/InfinitePaging

final class MainViewController: UIViewController {

    // MEMO: InterfaceBuilder上における設定のポイント
    // 1つのStoryboardの中で下記3つの部品を配置する

    // (1) categoryTabCollectionView:
    // 無限スクロールをするためのタブ型表現用UICollectionView

    // (2) categoryTabSelectBarView:
    // 無限スクロールタブ表示をした文字表示と連動するバー表示をするUIView

    // (3) categoryContentsContainerView:
    // 無限スクロールタブ表示をしたカテゴリーに紐づくコンテンツ一覧表示をするContainerView

    // MARK: - Properties

    // タブ型UICollectionViewにおける表示セルをコピーする倍数
    private let cellCopyCount: Int = 5

    // 現在表示しているViewControllerのタグ番号
    private var selectedPageViewControllerIndex: Int = 0

    // 無限スクロールタブ部分に表示するカテゴリーデータを保持する配列
    private var categoryLists: [String] = []

    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController!

    // 現在のセル番号
    private var selectedCollectionViewIndex: Int!

    // タブ型UICollectionViewにおけるX軸方向のScroll開始位置
    private var startCollectionViewPosX: CGFloat = 0

    // MARK: - @IBOutlet

    @IBOutlet private weak var categoryTabCollectionView: UICollectionView!
    @IBOutlet private weak var categoryTabSelectBarView: UIView!
    @IBOutlet private weak var categoryContentsContainerView: UIView!

    // MEMO: バー表示をするUIViewの幅に関する制約
    @IBOutlet private weak var categoryTabSelectBarViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryTab()
        setupCategoryTabCollectionView()
        setupCategoryTabSelectBarView()
        setupCategoryContentsPageViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Private Function

    // タブに表示したいカテゴリー名を取得してセットする
    private func setupCategoryTab() {
        
    }

    // タブ型表現用UICollectionViewの初期設定
    private func setupCategoryTabCollectionView() {

        categoryTabCollectionView.delegate = self
        categoryTabCollectionView.dataSource = self
        categoryTabCollectionView.registerCustomCell(CategoryTabCollectionViewCell.self)

        categoryTabCollectionView.delaysContentTouches = false
        categoryTabCollectionView.showsHorizontalScrollIndicator = false
        categoryTabCollectionView.showsVerticalScrollIndicator = false
    }

    // バー表示をするUIViewの初期設定
    private func setupCategoryTabSelectBarView() {

        categoryTabSelectBarView.backgroundColor = Constants.Color.categoryTabActive
        categoryTabSelectBarView.layer.cornerRadius = 14.0
        categoryTabSelectBarView.layer.masksToBounds = true
    }

    // タブに表示するカテゴリー名に対応する画面を構築する
    private func setupCategoryContentsPageViewController() {

        // MEMO: 現時点ではダミー表示用のViewControllerをセットしている
        (0...8).forEach { index in
            // MEMO: タブ型UI部分に配置したいViewControllerの一覧をインスタンスにして格納配列に配置する
            let targetViewController = SampleViewController.instantiate()
            targetViewControllerLists.append(targetViewController)
        }

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        // MEMO: StoryboardでContainerViewを経由してUIPageViewControllerを配置している点に注意する
        self.children.forEach { childViewController in
            guard let targetViewController = childViewController as? UIPageViewController else {
                return
            }
            pageViewController = targetViewController
        }

        // UIPageViewControllerにおけるUIScrollViewDelegateの宣言
        pageViewController.view.subviews.forEach { subView in
            guard let scrollView = subView as? UIScrollView else {
                return
            }
            scrollView.delegate = self
        }
    }

    // 前後のViewControllerを読み込む
    private func setNextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        // MEMO: 現在表示中のインデックス値を取得する
        guard let currentIndex = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // MEMO: 第2引数の設定に合わせて現在のインデックス値に+1または-1をするかを決定する（※表示する画面を決定するためのもの）
        let newIndex = isAfter ? (currentIndex + 1) : (currentIndex - 1)

        // MEMO: 新たに算出したインデックス値に対応するUIPageViewControllerに表示する画面を決定する
        switch newIndex {
        case newIndex where (newIndex < 0):
            return targetViewControllerLists.last
        case newIndex where (newIndex == targetViewControllerLists.count - 1):
            return targetViewControllerLists.first
        case newIndex where (newIndex > 0 && newIndex < targetViewControllerLists.count - 1):
            return targetViewControllerLists[newIndex]
        default:
            return nil
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {

    // セルの矩形サイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CategoryTabCollectionViewCell.cellWidth, height: CategoryTabCollectionViewCell.cellHeight)
    }

    // セルの垂直方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }

    // セルの水平方向の余白(margin)を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }

    // セル内のアイテム間の余白(margin)調整を行う
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}
