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

        setupCategoryTabCollectionView()
        setupCategoryTabSelectBarView()
        setupCategoryContentsPageViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Private Function

    private func setupCategoryTabCollectionView() {

        // MEMO: タブ型表現用UICollectionViewの初期設定

        categoryTabCollectionView.delegate = self
        categoryTabCollectionView.dataSource = self
        categoryTabCollectionView.registerCustomCell(CategoryTabCollectionViewCell.self)

        categoryTabCollectionView.delaysContentTouches = false
        categoryTabCollectionView.showsHorizontalScrollIndicator = false
        categoryTabCollectionView.showsVerticalScrollIndicator = false
    }

    private func setupCategoryTabSelectBarView() {

        // MEMO: バー表示をするUIViewの初期設定

        categoryTabSelectBarView.backgroundColor = Constants.Color.categoryTabActive
        categoryTabSelectBarView.layer.cornerRadius = CategoryTabCollectionViewCell.cellHeight / 2
        categoryTabSelectBarView.layer.masksToBounds = true
    }

    private func setupCategoryContentsPageViewController() {

        // MEMO: StoryboardでContainerViewを経由してUIPageViewControllerを配置している点に注意する

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
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
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
}
