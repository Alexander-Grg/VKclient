//
//  UserProfileBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//

import UIKit

final class UserProfileFlowBuilder {
    static func build(user: UserRealm, index: Int?) -> (UIViewController & UserProfileInput) {
        let presenter = UserProfilePresenter(user: user,
                                             index: index)
        let viewController = UserProfileViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
