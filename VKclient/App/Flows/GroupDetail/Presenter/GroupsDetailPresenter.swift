//
//  GroupsDetailPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit
import RealmSwift

protocol GroupsDetailInput: AnyObject {

}

protocol GroupsDetailOutput: AnyObject {

}

final class GroupsDetailPresenter {
    
    weak var viewInput: (UIViewController & GroupsDetailInput)?
    let group: GroupsObjects?

    init(group: GroupsObjects?) {
        self.group = group
    }


}

extension GroupsDetailPresenter: GroupsDetailOutput {

}
