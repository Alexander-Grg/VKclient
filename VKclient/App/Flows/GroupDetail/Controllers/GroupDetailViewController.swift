//
//  GroupDetailViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit

class GroupDetailViewController: UIViewController {

    let groupsDetailView = GroupDetailView()
    weak var presenter: GroupsDetailOutput?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func loadView() {
        super.loadView()
        self.view = groupsDetailView
    }

}

extension GroupDetailViewController: GroupsDetailInput {
    
}
