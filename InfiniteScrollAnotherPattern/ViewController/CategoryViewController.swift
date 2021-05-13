//
//  CategoryViewController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/02/23.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {

    // MARK: - Properties

    private var category: Category?

    // MARK: - @IBOutlet
    
    @IBOutlet private weak var categoryLabel: UILabel!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        if let category = category {
            let categoryIndex = "Index値: \(category.id)"
            let categoryTitle = "Category名: \(category.title)"

            categoryLabel.text = [categoryIndex, categoryTitle].joined(separator: "\n")
        } else {
            assertionFailure("CategoryのViewObjectがnilである")
        }
    }

    // MARK: - Function

    func setCategory(_ category: Category) {
        self.category = category
    }
}

// MARK: - StoryboardInstantiatable

extension CategoryViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return CategoryViewController.className
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
