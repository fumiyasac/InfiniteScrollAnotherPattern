//
//  CarouselScrollView.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/08/03.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: UIScrollViewを継承したカルーセル表示用のクラス
final class CarouselScrollView: UIScrollView {

    // UIScrollView内に内包するViewを定義する
    let contentView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))

    // カルーセル部分のタイトル表示部分全体幅
    var allCarouselWidth: CGFloat = 0.0

    // MARK: - Computed Properties

    // カルーセル部分のタイトル表示部分におけるView要素の配列
    var carouselTitleViews: [CarouselTitleView] {
        return contentView.subviews.compactMap { $0 as? CarouselTitleView }
    }

    // 表示されている部分のFrame値
    var visibleFrame: CGRect {
        return convert(bounds, to: contentView)
    }

    // MARK: - Function

    // カルーセル表示の中身の部分を配置する
    func setupCarousel(contentsViewList: [CarouselContentsView], isSelection: Bool = false) {

        contentView.translatesAutoresizingMaskIntoConstraints = false

        // MEMO: UIScrollView内に内包するUIViewの大きさに関する制約を設定する
        // 1. 高さは44pxで固定にする
        // 2. 幅は0以上にする
        let sizeConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(
                item: contentView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 44.0
            ),
            NSLayoutConstraint(
                item: contentView,
                attribute: .width,
                relatedBy: .greaterThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 0.0
            )
        ]
        NSLayoutConstraint.activate(sizeConstraints)
        addSubview(contentView)

        // MEMO: UIScrollView内に内包するUIViewのマージンに関する制約を設定する
        // 1. 上下左右のマージンを0にする
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        var marginConstraints: [NSLayoutConstraint] = []
        for attribute in attributes {
            marginConstraints.append(
                NSLayoutConstraint(
                    item: contentView,
                    attribute: attribute,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: attribute,
                    multiplier: 1.0,
                    constant: 0.0
                )
            )
        }
        NSLayoutConstraint.activate(marginConstraints)

        // 現段階でのタイトル長さからUIScrollViewのcontentSize.widthに相当しうる値を算出する
        // MEMO: タイトル名ベースのラベル長さを順次加算していく
        var temporaryTotalTitleViewWidth: CGFloat = 0.0
        for contentsView in contentsViewList {
            let targetTitle = contentsView.carouselTitle ?? ""
            temporaryTotalTitleViewWidth += CarouselTitleView.getLabelWidth(title: targetTitle)
        }
        // MEMO: 画面幅サイズ - タイトルラベル長さの合計値を算出して配置するタイトル部分の余白を算出する
        let allSurplusWidth = UIScreen.main.bounds.width - temporaryTotalTitleViewWidth
        let targetSurplusWidth = allSurplusWidth > 0.0 ? allSurplusWidth / CGFloat(contentsViewList.count) : 0.0

        // MEMO: コンテンツ表示用のViewを実際の表示数×3追加する
        for _ in 1...3 {
            for contentsView in contentsViewList {

                // UIScrollView内のContentViewに追加するView要素を初期化する
                let targetTitle = contentsView.carouselTitle ?? ""
                let carouselTitleView = CarouselTitleView()

                // MEMO: UIScrollView内のContentViewに追加するView要素を初期化する
                carouselTitleView.translatesAutoresizingMaskIntoConstraints = false
                carouselTitleView.backgroundColor = isSelection ? UIColor.red : UIColor.white

                // MEMO: ここで余白やタイトル文言をセットする
                carouselTitleView.setCarousel(
                    title: targetTitle,
                    color: isSelection ? .white : .black,
                    contentKey: contentsView.contentKey ?? "",
                    surplusWidth: targetSurplusWidth
                )
                contentView.addSubview(carouselTitleView)
            }
        }
        contentView.layoutIfNeeded()

        // 配置したCarouselTitleViewへそれぞれ制約を付与する
        setConstraintsOfCarouselTitleViews()
    }

    // MARK: - Private Function

    // 配置済みのCarouselTitleView要素に対してAutoLayoutの制約を付与する
    private func setConstraintsOfCarouselTitleViews() {
  
        var previousView: UIView?
        let carouselTitleHeight = bounds.height

        // 配置した個数分だけループさせてAutoLayoutの制約を適用する
        let lastIndex = contentView.subviews.count - 1
        for (index, view) in contentView.subviews.enumerated() {

            // MEMO: 幅と高さの制約を付与する
            let viewConstraints: [NSLayoutConstraint] = [
                NSLayoutConstraint(
                    item: view,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1.0,
                    constant: carouselTitleHeight
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1.0,
                    constant: view.bounds.width
                )
            ]
            NSLayoutConstraint.activate(viewConstraints)

            // MEMO: 上下方向の制約を付与する
            var constraints: [NSLayoutConstraint] = [
                NSLayoutConstraint(
                    item: view,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .top,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                NSLayoutConstraint(
                    item: view,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: contentView,
                    attribute: .bottom,
                    multiplier: 1.0,
                    constant: 0.0
                )
            ]

            // MEMO: 内包しているcontentViewのframe値を決定する
            contentView.frame = CGRect(x: 0.0, y: 0.0, width: contentView.frame.width + view.bounds.width, height: carouselTitleHeight)

            // MEMO: 一番最後の要素に対する制約を付与する
            if index == lastIndex {
                constraints.append(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .trailing,
                        relatedBy: .equal,
                        toItem: contentView,
                        attribute: .trailing,
                        multiplier: 1.0,
                        constant: 0.0
                    )
                )
            }

            // MEMO: 左隣に要素が存在する場合とそうでない場合の制約を付与する
            if let previousView = previousView {
                constraints.append(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .leading,
                        relatedBy: .equal,
                        toItem: previousView,
                        attribute: .trailing,
                        multiplier: 1.0,
                        constant: 0.0
                    )
                )
            } else {
                constraints.append(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .leading,
                        relatedBy: .equal,
                        toItem: contentView,
                        attribute: .leading,
                        multiplier: 1.0,
                        constant: 0.0
                    )
                )
            }
            NSLayoutConstraint.activate(constraints)

            // MEMO: 左隣にある要素となるものを変数へ入れておく
            previousView = view
        }

        // AutoLayout制約の更新を適用する
        layoutIfNeeded()

        // MEMO: タイトルのカルーセル表示部分の全体1セットはUIScrollViewに配置した長さの1/3である
        if allCarouselWidth == 0.0 {
            allCarouselWidth = floor(contentSize.width / 3.0)
        }
        contentOffset.x = allCarouselWidth
    }
}
