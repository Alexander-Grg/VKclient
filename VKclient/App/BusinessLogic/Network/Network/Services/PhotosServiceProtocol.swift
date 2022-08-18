//
//  PhotosServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//

import Foundation
import Combine

protocol PhotosServiceProtocol {
    func requestPhotos(id: String) -> AnyPublisher<Data, Error>
}

final class PhotosService: PhotosServiceProtocol {

    private let apiProvider = APIProvider<PhotosEndpoint>()
    
    func requestPhotos(id: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getPhotos(id: id))
            .eraseToAnyPublisher()
    }
}

