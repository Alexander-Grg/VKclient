//
//  NewsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class FeedFlowBuilder {
    static func buildNewsFeed(type: CurrentFeedType) -> (UIViewController & FeedFlowInput) {
        let presenter = FeedFlowPresenter(type: .newsFeed)
        let viewController = FeedTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }

    static func buildUserWall(id: String, type: CurrentFeedType) -> (UIViewController & FeedFlowInput) {
        let presenter = FeedFlowPresenter(userID: id, type: .friendFeed)
        let viewController = FeedTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }

    static func buildGroupWall(id: String, type: CurrentFeedType) -> (UIViewController & FeedFlowInput) {
        let presenter = FeedFlowPresenter(communityID: id, type: .groupFeed)
        let viewController = FeedTableViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}


