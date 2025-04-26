//
//  APIProvider.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import Combine
import KeychainAccess

class APIProvider<Endpoint: EndpointProtocol> {
    func getData(from endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        guard let request = performRequest(for: endpoint) else {
            return Fail(error: APIProviderErrors.invalidURL)
                .eraseToAnyPublisher()
        }
        return loadData(with: request)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Request building
    private func performRequest(for endpoint: Endpoint) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.absoluteURL) else {
            return nil
        }

        let keychainToken = try? Keychain().get("token")

        urlComponents.queryItems = endpoint.parameters.compactMap({ param -> URLQueryItem in
            return URLQueryItem(name: param.key, value: param.value)
        })
        
        urlComponents.queryItems?.append(URLQueryItem(name: "access_token", value: keychainToken))
        urlComponents.queryItems?.append(URLQueryItem(name: "v", value: "5.131"))
        
        guard let url = urlComponents.url else {
            return nil
        }

        let urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadRevalidatingCacheData,
                                    timeoutInterval: 30)
        print(keychainToken)
        return urlRequest
    }
    
    // MARK: - Getting data
    private func loadData(with request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
