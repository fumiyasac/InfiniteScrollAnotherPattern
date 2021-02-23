//
//  SampleViewController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/02/23.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import UIKit

final class SampleViewController: UIViewController {

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - StoryboardInstantiatable

extension SampleViewController: StoryboardInstantiatable {

    // このViewControllerに対応するStoryboard名
    static var storyboardName: String {
        return SampleViewController.className
    }

    // このViewControllerに対応するViewControllerのIdentifier名
    static var viewControllerIdentifier: String? {
        return nil
    }
}
