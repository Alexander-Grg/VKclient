//
//  SearchGroupsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import Foundation
import UIKit
import Combine

protocol SearchGroupsFlowViewInput: AnyObject {
    func updateTableView()
}

protocol SearchGroupsFlowViewOutput: AnyObject {
    var groupsHolder: [GroupsObjects] { get }
    var searchTextForGroup: String { get set }
    func didSearch(_ searchText: String)
    func toTheGroupDetails(index: IndexPath)
}

final class SearchGroupsFlowPresenter {
    @Injected(\.groupsSearchService) var groupsSearchService
    private var cancellable = Set<AnyCancellable>()
    var groupsHolder = [GroupsObjects]() {
        didSet {
            self.viewInput?.updateTableView()
        }
    }
    weak var viewInput: (UIViewController & SearchGroupsFlowViewInput)?
    
    var searchTextForGroup: String = ""
    
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
    
    private func toTheExactGroup(index: IndexPath) {
        let groups = self.groupsHolder[index.row]
        let nextVC = GroupsDetailModuleBuilder.buildForNetworkGroups(groups)
        self.viewInput?.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension SearchGroupsFlowPresenter: SearchGroupsFlowViewOutput {
    func didSearch(_ searchText: String) {
        self.searchForGroups(searchText)
    }
    
    func toTheGroupDetails(index: IndexPath) {
        self.toTheExactGroup(index: index)
    }
}
