//
//  CategoryTab.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/02/23.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

struct CategoryTab: Hashable, Equatable {
    let id: Int
    let title: String
    let slug: String
    
    // MARK: - Initializer

    init(id: Int, title: String, slug: String) {
        self.id = id
        self.title = title
        self.slug = slug
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CategoryTab, rhs: CategoryTab) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.slug == rhs.slug
    }
}
