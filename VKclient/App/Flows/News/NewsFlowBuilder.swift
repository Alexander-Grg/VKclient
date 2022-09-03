//
//  NewsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
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


