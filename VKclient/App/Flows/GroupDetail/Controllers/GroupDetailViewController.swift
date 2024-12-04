//
//  GroupDetailViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit

class GroupDetailViewController: UIViewController {

    var groupsDetailView = GroupDetailView()
    private let presenter: GroupsDetailOutput

    init(presenter: GroupsDetailOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = groupsDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        groupsDetailView.delegate = self
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupsDetailView.setupJoinLeaveButton(isJoined: presenter.isMember)
    }
}

extension GroupDetailViewController: GroupsDetailInput {
    
}

extension GroupDetailViewController: GroupDetailDelegate {
    
    func didInviteTap(_ isTapped: Bool) {
        if isTapped {
            presenter.joinGroup()
        }
    }
}
