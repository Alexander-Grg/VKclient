//
//  Factory.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.01.2022.
//

import Foundation
import SDWebImage
import UIKit

struct GroupsViewModel {
    var name: String
    var photo: URL!
}

final class GroupsViewModelFactory {
    func constructViewModels(from groups: [GroupsObjects]) -> [GroupsViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(from group: GroupsObjects) -> GroupsViewModel {
        let name = String(group.name)
        let photo = URL(string: group.photo)
     return GroupsViewModel(name: name, photo: photo)
    }
}

