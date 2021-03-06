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

    // 現在表示しているUIPageViewControllerのインデックス番号
    private var selectedPageViewControllerIndex: Int = 0

    // 無限スクロールタブ部分に表示するカテゴリーデータを保持する配列
    private var categoryTabLists: [CategoryTab] = []

    // ページングして表示させるViewControllerを保持する配列
    private var targetViewControllerLists: [UIViewController] = []

    // ContainerViewにEmbedしたUIPageViewControllerのインスタンスを保持する
    private var pageViewController: UIPageViewController!

    // 現在のカテゴリー表示用のUICollectionViewのインデックス番号
    private var selectedCollectionViewIndex: Int?

    // コンテンツ配置用PageViewControllerにおけるX軸方向のScroll開始位置
    private var startPageViewControllerPosX: CGFloat = 0

    // タブ型UICollectionViewにおけるX軸方向のScroll開始位置
    private var startCollectionViewPosX: CGFloat = 0

    // ボタン押下時の軽微な振動を追加する
    private let buttonFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    // MARK: - @IBOutlet

    @IBOutlet private weak var categoryTabCollectionView: UICollectionView!
    @IBOutlet private weak var categoryTabSelectBarView: UIView!
    @IBOutlet private weak var categoryContentsContainerView: UIView!

    // MEMO: UIPageViewControllerの高速スクロール防止用UIView
    @IBOutlet private weak var preventHighSpeedScrollCoverView: UIView!
    
    // MEMO: バー表示をするUIViewの幅に関する制約
    @IBOutlet private weak var categoryTabSelectBarViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarTitle("べんりな情報")
        setupCategoryTab()
        setupCategoryTabCollectionView()
        setupPreventHighSpeedScrollCoverView()
        setupCategoryTabSelectBarView()
        setupCategoryContentsPageViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // タブ位置と表示画面の初期状態を設定する
        selectedCollectionViewIndex = categoryTabLists.count
        let initialIndexPath = IndexPath(row: categoryTabLists.count, section: 0)
        changeScreenByScrollContents(at: initialIndexPath)
    }

    // MARK: - Private Function (Initialize about UserInterface)

    // タブに表示したいカテゴリー名を取得してセットする
    private func setupCategoryTab() {
        categoryTabLists = [
            CategoryTab(id: 1, title: "おすすめ", slug: "recommend"),
            CategoryTab(id: 2, title: "グルメ", slug: "gourmet"),
            CategoryTab(id: 3, title: "くらし情報", slug: "lifestyle"),
            CategoryTab(id: 4, title: "ファッション", slug: "fashion"),
            CategoryTab(id: 5, title: "お役立ち", slug: "useful"),
            CategoryTab(id: 6, title: "おうち生活", slug: "meals"),
            CategoryTab(id: 7, title: "記事カテゴリー", slug: "article_category"),
            CategoryTab(id: 8, title: "フォトカテゴリー", slug: "photo_category")
        ]
    }

    // タブ型表現用UICollectionViewの初期設定
    private func setupCategoryTabCollectionView() {

        // MEMO: InterfaceBuilder内でUICollectionViewにおけるレイアウト属性計算用クラス「CategoryTabCollectionViewFlowLayout」を設定する
        categoryTabCollectionView.delegate = self
        categoryTabCollectionView.dataSource = self
        categoryTabCollectionView.registerCustomCell(CategoryTabCollectionViewCell.self)

        // MEMO: InterfaceBuilder上で下記の設定をする
        // - 項目: 「Scroll Drection」をHorizontalに設定する
        // - 項目: 「Estimate Size」をNoneに設定する
        categoryTabCollectionView.delaysContentTouches = false
        categoryTabCollectionView.showsHorizontalScrollIndicator = false
        categoryTabCollectionView.showsVerticalScrollIndicator = false
        categoryTabCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    // UIPageViewControllerの高速スクロール防止用UIViewの初期設定
    private func setupPreventHighSpeedScrollCoverView() {

        // MEMO: 最初はスクロールができる様にするために非表示にする
        preventHighSpeedScrollCoverView.isHidden = true
    }

    // バー表示をするUIViewの初期設定
    private func setupCategoryTabSelectBarView() {

        categoryTabSelectBarView.backgroundColor = Constants.Colors.primary
        categoryTabSelectBarView.layer.cornerRadius = 12.0
        categoryTabSelectBarView.layer.masksToBounds = true
    }

    // タブに表示するカテゴリー名に対応する画面を構築する
    private func setupCategoryContentsPageViewController() {

        // MEMO: 現時点ではダミー表示用のViewControllerをセットしている
        (0..<categoryTabLists.count).forEach { index in
            // MEMO: タブ型UI部分に配置したいViewControllerの一覧をインスタンスにして格納配列に配置する
            // FIXME: 正規の画面に後程差し替える
            let targetViewController = SampleViewController.instantiate()
            targetViewController.setIndex(index)
            targetViewControllerLists.append(targetViewController)
        }

        // ContainerViewにEmbedしたUIPageViewControllerを取得する
        // MEMO: StoryboardでContainerViewを経由してUIPageViewControllerを配置している点に注意する
        // MEMO: InterfaceBuilder上で「Transition Style」をScrollに設定する
        self.children.forEach { childViewController in
            guard let targetViewController = childViewController as? UIPageViewController else {
                return
            }
            pageViewController = targetViewController
        }

        // UIPageViewControllerDelegate & UIPageViewControllerDataSourceの宣言
        if let targetPageViewController = pageViewController {
            targetPageViewController.delegate = self
            targetPageViewController.dataSource = self

            // 最初に表示する画面として配列の先頭のViewControllerを設定する
            targetPageViewController.setViewControllers([targetViewControllerLists[0]], direction: .forward, animated: false, completion: nil)
        }

        // UIPageViewControllerにおけるUIScrollViewDelegateの宣言
        pageViewController.view.subviews.forEach { subView in
            guard let scrollView = subView as? UIScrollView else {
                return
            }
            scrollView.delegate = self
            scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }

    // MARK: - Private Function (Change State Function about UserInterface)

    // スクロールイベントを起点とした表示する画面とタブ位置の調節を実施する
    private func changeScreenByScrollContents(at indexPath: IndexPath) {
        
        // 表示画面数とカテゴリー数が異なるかの確認
        if categoryTabLists.count != targetViewControllerLists.count {
            assertionFailure("表示画面数とカテゴリー数が異なる")
            return
        }

        // 画面状態更新処理
        changePageViewControllerPosition(at: indexPath, animated: false)
    }

    // タブのタップイベントを起点とした表示する画面とタブ位置の調節を実施する
    private func changeScreenByTabTap(at indexPath: IndexPath) {

        // タップされたタブのインデックス値を取得する
        selectedCollectionViewIndex = indexPath.row % categoryTabLists.count + (categoryTabLists.count - 1)

        // 画面状態更新処理
        changePageViewControllerPosition(at: indexPath, animated: true)
    }

    // タブとUIPageViewController画面状態を更新するための処理
    private func changePageViewControllerPosition(at indexPath: IndexPath, animated: Bool) {

        if let targetPageViewController = pageViewController {

            // UIPageViewControllerの表示位置を更新する
            targetPageViewController.setViewControllers([targetViewControllerLists[indexPath.row % categoryTabLists.count]], direction: .forward, animated: false, completion: {  _ in

                // 現在表示中のUIPageViewControllerのインデックス値を更新
                self.selectedPageViewControllerIndex = indexPath.row % self.categoryTabLists.count

                // 「コツッ」とした感じの端末フィードバックを発火する
                self.buttonFeedbackGenerator.impactOccurred()
            })

            // 引数で渡されたIndexPathの値に合致する位置までセルをスクロールする
            categoryTabCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)

            // タブのデザイン状態の更新
            DispatchQueue.main.async {
                self.changeCategoryTabDesign(at: indexPath)
            }
        }
    }
    
    // タブのデザイン適用を実施する
    private func changeCategoryTabDesign(at indexPath: IndexPath) {
        
        // まずは見えているセル全ての配色を全てリセットする
        for visibleCell in categoryTabCollectionView.visibleCells {
            if let visibleCell = visibleCell as? CategoryTabCollectionViewCell {
                visibleCell.setColor(shouldActive: false)
            }
        }

        // 次に該当するセル要素を取得して配色を適用＆
        if let targetCell = categoryTabCollectionView.cellForItem(at: indexPath) as? CategoryTabCollectionViewCell {

            // セル要素に対して表示中の配色を適用する
            targetCell.setColor(shouldActive: true)

            // バー表示をするUIViewの幅をアニメーションを伴って表示文字幅に合わせる
            let additionnalWidth: CGFloat = 16.0
            let targetCellCharacterWidth = targetCell.getCharacterWidthWithinCell()
            categoryTabSelectBarViewWidthConstraint.constant = targetCellCharacterWidth + additionnalWidth
            UIView.animate(withDuration: 0.18, animations: {
                self.categoryTabSelectBarView.setNeedsLayout()
                self.categoryTabSelectBarView.layoutIfNeeded()
            })

        } else {
            selectedCollectionViewIndex = nil
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    // セルを選択した際のふるまいを設定する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeScreenByTabTap(at: indexPath)
    }
}

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
        return categoryTabLists.count * cellCopyCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: CategoryTabCollectionViewCell.self, indexPath: indexPath)
        let index = indexPath.row % categoryTabLists.count
        let categoryTab = categoryTabLists[index]
        cell.setCell(categoryTab)
        return cell
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    
    // ページが動いたタイミング（この場合はスワイプアニメーションに該当）に実行したい処理を記載するメソッド
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        // スワイプアニメーションが完了していない時は以降の処理は実施しない
        preventHighSpeedScrollCoverView.isHidden = true

        // スワイプアニメーションが完了していない時は以降の処理は実施しない
        if !completed { return }

        // ここから先はUIPageViewControllerのスワイプアニメーション完了時に発動する
        // MEMO: 表示対象のViewController要素からインデックス値を割り出して、選択中selectedPageViewControllerIndexへ反映する
        if let targetViewController = pageViewController.viewControllers?.first {
            guard let targetIndex = targetViewControllerLists.firstIndex(of: targetViewController) else {
                return
            }
            selectedPageViewControllerIndex = targetIndex
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {

    // 逆方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return setNextViewController(viewController, isAfter: false)
    }

    // 順方向にページ送りした時に呼ばれるメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return setNextViewController(viewController, isAfter: true)
    }

    // UIPageViewControllerをページ送りした際に表示させるViewControllerを設定する
    private func setNextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {

        // MEMO: 現在表示中のインデックス値を取得する
        guard let currentIndex = targetViewControllerLists.firstIndex(of: viewController) else {
            return nil
        }

        // MEMO: 第2引数の設定に合わせて現在のインデックス値に+1または-1をするかを決定する（※表示する画面を決定するためのもの）
        var newIndex = isAfter ? (currentIndex + 1) : (currentIndex - 1)

        // MEMO: 新たに算出したインデックス値に対応するUIPageViewControllerに表示する画面を決定する
        if newIndex < 0 {
            newIndex = targetViewControllerLists.count - 1
        } else if newIndex == targetViewControllerLists.count {
            newIndex = 0
        }

        let shouldReturnNextViewController = (newIndex >= 0 && newIndex < targetViewControllerLists.count)
        if shouldReturnNextViewController {
            return targetViewControllerLists[newIndex]
        } else {
            return nil
        }
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {

    // UIScrollViewをタップしてスクロールが開始された時に実行される処理
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        // UIPageViewControllerにおけるスクロール開始位置のX座標をセット
        startPageViewControllerPosX = scrollView.contentOffset.x

        // UICollectionViewの位置調整用の計算処理
        let categoryTabContentWidth = categoryTabCollectionView.contentSize.width / CGFloat(cellCopyCount)
        let categoryTabContentOffsetX = categoryTabContentWidth * 2 + (CategoryTabCollectionViewCell.cellWidth * CGFloat(selectedPageViewControllerIndex))
        let categoryTabContentCenterMargin = (UIScreen.main.bounds.size.width - CategoryTabCollectionViewCell.cellWidth) / 2

        // UICollectionViewにおけるスクロール開始位置のX座標をセット
        startCollectionViewPosX = categoryTabContentOffsetX - categoryTabContentCenterMargin
    }

    // UIScrollViewのスクロール操作中に実行される処理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // UIScrollViewのスクロールがタブで実行されたものかを判定する
        let isCategoryTabCollectionViewScroll: Bool = (scrollView == categoryTabCollectionView)

        // (1) UICollectionViewのスクロールであった場合
        if isCategoryTabCollectionViewScroll {

            // MEMO: ここでは閾値を超過した際に無限スクロールに見せるために中央にもどす処理を実施している
            let categoryTabContentWidth = categoryTabCollectionView.contentSize.width / CGFloat(cellCopyCount)

            // UICollectionViewが左側の閾値を超過した場合
            if categoryTabCollectionView.contentOffset.x <= CategoryTabCollectionViewCell.cellWidth {
                categoryTabCollectionView.contentOffset.x = (categoryTabContentWidth * 2) + CategoryTabCollectionViewCell.cellWidth
            // UICollectionViewが右側の閾値を超過した場合
            } else if (categoryTabCollectionView.contentOffset.x) >= (categoryTabContentWidth * 3) + CategoryTabCollectionViewCell.cellWidth {
                categoryTabCollectionView.contentOffset.x = categoryTabContentWidth + CategoryTabCollectionViewCell.cellWidth
            }

        // (2) UIPageViewControllerのスクロールであった場合
        } else {

            // UIPageViewControllerとUICollectionViewのX座標の変化量を算出する
            let changedPageViewControllerPosX = startPageViewControllerPosX - scrollView.contentOffset.x
            let changedCollectionViewPosX = CategoryTabCollectionViewCell.cellWidth * (changedPageViewControllerPosX / UIScreen.main.bounds.size.width)

            // UIPageViewControllerがスクロール状態の場合は高速スクロール防止用UIViewを表示させる
            if abs(changedPageViewControllerPosX) > 0 && abs(changedPageViewControllerPosX) < UIScreen.main.bounds.size.width {
                preventHighSpeedScrollCoverView.isHidden = false
            }
            
            // UIPageViewControllerを動かした分だけUICollectionViewも一緒に動作させる
            if changedCollectionViewPosX != 0 {
                categoryTabCollectionView.contentOffset.x = startCollectionViewPosX - changedCollectionViewPosX
            }
        }

        // スクロール中にも真ん中にあるタブのデザイン状態の更新を実行する
        let collectionViewCenter = self.view.convert(categoryTabCollectionView.center, to: categoryTabCollectionView)
        guard let targetIndexPath = categoryTabCollectionView.indexPathForItem(at: collectionViewCenter) else {
            return
        }
        if targetIndexPath.row != selectedCollectionViewIndex {
            changeCategoryTabDesign(at: targetIndexPath)
        }
    }

    // UIScrollViewから指が離れてその後も慣性スクロールが発生しうる場合に実行される処理
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // 完全に止まる瞬間はdecelerateはfalseとなるのでその時にスクロールが止まった時の処理を実行する
        if !decelerate {
            handleScrollForCenteringCategoryTab(scrollView)
        }
    }

    // UIScrollViewのスクロールが急停止した時に実行される処理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // スクロールが止まった時の処理を実行する
        handleScrollForCenteringCategoryTab(scrollView)
    }

    // スクロールが停止した時にUIPageViewControllerとUICollectionViewの画面状態をハンドリングする
    private func handleScrollForCenteringCategoryTab(_ scrollView: UIScrollView) {

        // スクロールが終わったら再度スクロールができる様にするために非表示にする
        preventHighSpeedScrollCoverView.isHidden = true

        // 当該箇所のIndexPathを取得して画面状態の更新処理を実行する
        let collectionViewCenter = self.view.convert(categoryTabCollectionView.center, to: categoryTabCollectionView)
        guard let targetIndexPath = categoryTabCollectionView.indexPathForItem(at: collectionViewCenter) else {
            return
        }
        changeScreenByScrollContents(at: targetIndexPath)
    }
}
