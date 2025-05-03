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
    private let presenter: CommentsFlowViewOutput

    private(set) lazy var commentsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 150
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.loadData()
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

    func updateSpecificPost(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if index < presenter.comments.count, commentsTableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            if let cell = commentsTableView.cellForRow(at: indexPath) as? CommentsFlowCell {
                let comment = presenter.comments[index]
                let displayName = presenter.getDisplayName(for: comment.fromID)
                cell.configureData(with: comment, displayName: displayName)
            }
        }
    }
}

extension CommentsFlowViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CommentsFlowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsFlowCell.identifier) as? CommentsFlowCell else {
            return UITableViewCell()
        }
        if indexPath.row < presenter.comments.count {
            let comment = presenter.comments[indexPath.row]
            let displayName = presenter.getDisplayName(for: comment.fromID)
            print("Configuring cell for comment ID: \(comment.id), displayName: \(displayName)")
            cell.configureData(with: comment, displayName: displayName)
            cell.likesButton.commentDelegate = self
        } else {
            print("Index out of bounds: \(indexPath.row) >= \(presenter.comments.count)")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.commentsTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CommentsFlowViewController: CommentsFlowViewInput {
    func reloadData() {
        commentsTableView.reloadData()
    }
}

extension CommentsFlowViewController: LikeCommentDelegate {
    func didLike(in cell: CommentsFlowCell?) {
        guard let cell = cell, let indexPath = commentsTableView.indexPath(for: cell) else { return }
        let comments = presenter.comments[indexPath.row]
        if comments.likes?.canLike == 1 {
            presenter.setLike(itemID: String(comments.id), ownerID: String(comments.ownerID ?? 0))
        } else {
            presenter.removeLike(itemID: String(comments.id), ownerID: String(comments.ownerID ?? 0))
        }
    }
}
