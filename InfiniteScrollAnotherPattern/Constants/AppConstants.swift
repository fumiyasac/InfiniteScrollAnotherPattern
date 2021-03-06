//
//  AppConstants.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/01/17.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: 本当はXcodeGen等を利用して自動生成できた方が良い
// https://github.com/SwiftGen/SwiftGen

struct Constants {

    // MARK: - Struct

    // このUI実装サンプルで利用する各種カラー定義
    struct Colors {
        static let primary: UIColor = UIColor(code: "#ee863f")
        static let navigationBarTitle: UIColor = UIColor.white
        static let categoryScrollTabDefault: UIColor = UIColor(code: "#bbbbbb")
        static let categoryScrollTabActive: UIColor = UIColor(code: "#eeeeee")
    }

    // このUI実装サンプルで利用する各種フォント定義
    struct FontStyles {
        static let navigationBarTitle: UIFont = UIFont(name: "HiraginoSans-W6", size: 14.0)!
        static let categoryScrollTab: UIFont = UIFont(name: "HiraginoSans-W6", size: 12.0)!
    }
}
