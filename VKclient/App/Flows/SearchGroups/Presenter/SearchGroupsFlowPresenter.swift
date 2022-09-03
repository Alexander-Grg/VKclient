//
//  SearchGroupsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import Foundation
import UIKit
import Combine

protocol SearchGroupsFlowViewInput {
    func updateTableView()
}

protocol SearchGroupsFlowViewOutput {
    var groupsHolder: [GroupsObjects] { get }
    func didSearch(_ searchText: String)
}

final class SearchGroupsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    private let groupsSearchService = GroupSearchService()
    var groupsHolder = [GroupsObjects]() {
        didSet {
            self.viewInput?.updateTableView()
        }
    }
    weak var viewInput: (UIViewController & SearchGroupsFlowViewInput)?
    
    private func searchForGroups(_ searchText: String) {
        if searchText.isEmpty {
            self.groupsHolder.removeAll()
        } else {
            groupsSearchService.requestGroupsSearch(search: searchText)
                .decode(type: GroupsResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { error in
                    print(error)
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.groupsHolder = value.response.items
                }
                )
                .store(in: &cancellable)
        }
    }
    
}

extension SearchGroupsFlowPresenter: SearchGroupsFlowViewOutput {
    func didSearch(_ searchText: String) {
        self.searchForGroups(searchText)
    }
}
