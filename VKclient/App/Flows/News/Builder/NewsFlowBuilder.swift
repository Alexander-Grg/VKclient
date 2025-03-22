//
//  NewsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class NewsFlowBuilder {
    static func build() -> (UIViewController & NewsFlowViewInput) {
        let presenter = NewsFlowPresenter()
        let viewController = NewsTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}


