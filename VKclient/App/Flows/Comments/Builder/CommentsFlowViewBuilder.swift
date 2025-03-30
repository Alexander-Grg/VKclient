//
//
//  CommentsFlowViewBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import UIKit

final class CommentsFlowViewBuilder {
    static func build(ownerID: Int, postID: Int) -> (UIViewController & CommentsFlowViewInput) {
        let presenter = CommentsFlowPresenter(ownerID: ownerID, postID: postID)
        let viewController = CommentsFlowViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}

