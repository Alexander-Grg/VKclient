//
//  PhotosFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
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
