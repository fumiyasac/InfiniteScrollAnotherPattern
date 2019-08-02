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
        return contentView.subviews.compactMap({ $0 as? CarouselTitleView })
    }

    // 表示されている部分のFrame値
    var visibleFrame: CGRect {
        return convert(bounds, to: contentView)
    }
}
