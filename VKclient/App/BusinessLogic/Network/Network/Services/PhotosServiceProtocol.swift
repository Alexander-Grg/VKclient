//
//  PhotosServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import Combine

struct PhotosServiceKey: InjectionKey {
   static var currentValue: PhotosServiceProtocol = PhotosService()
}

protocol PhotosServiceProtocol: AnyObject {
    func requestPhotos(id: String) -> AnyPublisher<Data, Error>
}

final class PhotosService: PhotosServiceProtocol {

    private let apiProvider = APIProvider<PhotosEndpoint>()
    
    func requestPhotos(id: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getPhotos(id: id))
            .eraseToAnyPublisher()
    }
}

