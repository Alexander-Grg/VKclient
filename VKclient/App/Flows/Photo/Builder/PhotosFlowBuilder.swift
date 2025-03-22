//
//  PhotosFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class PhotosFlowBuilder {
    static func build() -> (UIViewController & PhotosFlowViewInput) {
        let presenter = PhotosFlowPresenter()
        let viewController = PhotoViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
