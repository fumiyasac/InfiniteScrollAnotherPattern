//
//  CategoryScreenLayout.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/01/18.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

// MEMO: 無限スクロールを伴うタブ形UI表示に関する種別

enum CategoryScreenLayout: String {
    case waterfallGridStyle = "waterfall_grid"
    case articleListStyle = "article_list"
    case toggleCellStyle = "toggle_cell"
    
    // MARK: - Static Function

    static func getStyleBy(jsonKey: String) -> CategoryScreenLayout? {
        return CategoryScreenLayout(rawValue: jsonKey) ?? nil
    }
}
