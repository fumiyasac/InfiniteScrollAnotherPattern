//
//  MainViewController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/07/23.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import UIKit

// MEMO: 元記事＆元リポジトリを参考に無限すスクロールを実装する
// ← 元記事:
// ← 元リポジトリ:

final class MainViewController: UIViewController {

    @IBOutlet weak private var carouselScrollView: CarouselScrollView!
    @IBOutlet weak private var selectionCarouselScrollView: CarouselScrollView!
    @IBOutlet weak private var paginateScrollView: UIScrollView!

    private var carouselContentsViews: [CarouselContentsView] = []

    // MARK: - Enum

    private enum displayPosition: Int {
        // MEMO: コンテンツ表示部分のスクロール位置のEnum定義
        case left
        case center
        case right

        // MEMO: スクロール時に表示内容を入れ替えるために利用する
        func inverse() -> displayPosition {
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
        return nil
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension MainViewController: UIScrollViewDelegate {
}
