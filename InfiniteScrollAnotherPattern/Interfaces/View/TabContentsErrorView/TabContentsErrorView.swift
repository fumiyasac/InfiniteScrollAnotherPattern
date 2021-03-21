//
//  TabContentsErrorView.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/03/20.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TabContentsErrorViewDelegate

protocol TabContentsErrorViewDelegate: NSObjectProtocol {
    func reloadButtonTapped()
}

final class TabContentsErrorView: CustomViewBase {

    // MARK: - Property

    weak var delegate: TabContentsErrorViewDelegate?
}
