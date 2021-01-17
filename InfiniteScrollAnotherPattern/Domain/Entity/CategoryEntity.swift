//
//  CategoryEntity.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/01/18.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

struct CategoryEntity: Hashable, Decodable {

    let id: Int
    let title: String

    // MARK: - Enum

    private enum Keys: String, CodingKey {
        case id
        case title
    }

    // MARK: - Initializer

    init(id: Int, title: String) {

        // 初期化時に必要なものを渡す
        self.id = id
        self.title = title
    }

    init(from decoder: Decoder) throws {

        // JSONの配列内の要素を取得する
        let container = try decoder.container(keyedBy: Keys.self)

        // JSONの配列内の要素にある値をDecodeして初期化する
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }

    // MARK: - Hashable

    // MEMO: Hashableプロトコルに適合させるための処理

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CategoryEntity, rhs: CategoryEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
