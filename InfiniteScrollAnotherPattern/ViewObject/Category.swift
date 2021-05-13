//
//  Category.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/02/23.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

struct Category: Hashable, Equatable {
    let id: Int
    let title: String
    
    // MARK: - Initializer

    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
