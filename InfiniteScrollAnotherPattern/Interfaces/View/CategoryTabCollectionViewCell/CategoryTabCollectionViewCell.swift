//
//  CategoryTabCollectionViewCell.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/01/17.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import UIKit

final class CategoryTabCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    // タブ型UICollectionViewにおける表示セルをコピーする倍数
    static let cellWidth: CGFloat = 118.0
    static let cellHeight: CGFloat = 48.0

    // MARK: - @IBOutlet

    @IBOutlet private weak var categoryTitleLabel: UILabel!

    // MARK: - Function

    //
    func setCell(_ categoryTab: CategoryTab) {
        categoryTitleLabel.text = categoryTab.title
        setColor(shouldActive: false)
    }

    //
    func setColor(shouldActive: Bool) {
        categoryTitleLabel.textColor = shouldActive ? UIColor(code: "#dddddd") : UIColor(code: "#aaaaaa")
    }

    //
    func getCharacterWidthWithinCell() -> CGFloat {
        let targetText = categoryTitleLabel.text
        let targetAttributes = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 12.0)!]
        if let characterSize = targetText?.size(withAttributes: targetAttributes) {
            return characterSize.width
        } else {
            return CGFloat.zero
        }
    }
}
