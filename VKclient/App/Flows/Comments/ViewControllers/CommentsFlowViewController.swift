//
//
//  CommentsFlowViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import UIKit

final class CommentsFlowViewController: UIViewController {
    let mockComments = ["Hi, I am comment 1",
                        "Hi, I am comment 2",
                        "Hi, I am comment 3"]
    private let presenter: CommentsFlowViewOutput

    private(set) lazy var commentsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CommentsFlowCell.self, forCellReuseIdentifier: CommentsFlowCell.identifier)
        return table
    }()

    private(set) lazy var dragIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()

    init(presenter: CommentsFlowViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSheetPresentation()
        self.presenter.viewDidLoad()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true

        view.addSubview(dragIndicator)
        view.addSubview(commentsTableView)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dragIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dragIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragIndicator.widthAnchor.constraint(equalToConstant: 40),
            dragIndicator.heightAnchor.constraint(equalToConstant: 6),

            commentsTableView.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 8),
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
    }
}

extension CommentsFlowViewController: UITableViewDelegate {}

extension CommentsFlowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsFlowCell.identifier) as? CommentsFlowCell else {
            return UITableViewCell()
        }
        cell.configureData(with: presenter.comments[indexPath.row])
        return cell
    }
}

extension CommentsFlowViewController: CommentsFlowViewInput {
    func reloadData() {
        commentsTableView.reloadData()
    }
}
