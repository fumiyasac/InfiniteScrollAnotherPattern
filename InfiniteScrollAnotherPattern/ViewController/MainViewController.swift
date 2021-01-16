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

    // 現在表示しているViewControllerのタグ番号
    private var selectedPageViewControllerIndex: Int = 0

    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController? = nil

    // 現在のセル番号
    private var selectedCollectionViewIndex: Int!

    // タブ型UICollectionViewにおけるX軸方向のScroll開始位置
    private var startCollectionViewPosX: CGFloat = 0

    // タブ型UICollectionViewにおける表示セルをコピーする倍数
    private let cellCopyCount: Int = 5

    // MARK: - @IBOutlet

    @IBOutlet private weak var categoryTabCollectionView: UICollectionView!
    @IBOutlet private weak var categoryTabSelectBarView: UIView!
    @IBOutlet private weak var categoryContentsContainerView: UIView!

    // MARK: - Computed Property

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCategoryTabCollectionView()
        setupCategoryTabSelectBarView()
        setupCategoryContentsContainerView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Private Function

    private func setupCategoryTabCollectionView() {
        
    }

    private func setupCategoryTabSelectBarView() {
        
    }

    private func setupCategoryContentsContainerView() {
        
        // MEMO: StoryboardでContainerViewを経由してUIPageViewControllerを配置している点に注意する
    }
}
