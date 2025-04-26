//
//
//  CommentsFlowCell.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage

final class CommentsFlowCell: UITableViewCell {

    // MARK: - UI Components

    private(set) lazy var nameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private(set) lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private(set) lazy var mainDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private(set) lazy var likesButton: LikeControl = {
        let likesControl = LikeControl()
        likesControl.translatesAutoresizingMaskIntoConstraints = false
        likesControl.isUserInteractionEnabled = true
        return likesControl
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextLabel.text = ""
        mainDateLabel.text = ""
        mainTextLabel.text = ""
        likesButton.isLiked = false
        likesButton.likesCount = 0
    }

    // MARK: - Configuration

    func configureData(with comment: CommentModel, displayName: String) {
        nameTextLabel.text = displayName.isEmpty ? "Unknown" : displayName

        let initialText = comment.text.isEmpty ? "\n" : "\(comment.text) "
        mainTextLabel.attributedText = NSAttributedString(string: initialText)

        configureStickerIfNeeded(for: comment)
        configureLikes(for: comment)
        configureDate(timestamp: comment.date)
    }

    // MARK: - Private Methods

    private func configureStickerIfNeeded(for comment: CommentModel) {
        guard let sticker = comment.attachmentSticker.first,
              let url = URL(string: sticker.url) else { return }

        if comment.text.isEmpty {
            mainTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        }

        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] (image, _, error, _, _, _) in
            guard let self = self, let image = image else {
                if let error = error {
                    print("Failed to load sticker: \(sticker.url), error: \(error.localizedDescription)")
                }
                return
            }

            DispatchQueue.main.async {
                self.appendStickerToText(comment.text, image: image)
            }
        }
    }

    private func appendStickerToText(_ text: String, image: UIImage) {
        let attributedString = NSMutableAttributedString(string: text.isEmpty ? "" : "\(text) ")
        let attachment = createStickerAttachment(from: image)
        attributedString.append(NSAttributedString(attachment: attachment))
        mainTextLabel.attributedText = attributedString
        updateCellLayout()
    }

    private func createStickerAttachment(from image: UIImage) -> NSTextAttachment {
        let attachment = NSTextAttachment()
        attachment.image = image
        let maxSize: CGFloat = 100
        let aspectRatio = image.size.width / image.size.height
        let size = calculateProportionalSize(width: image.size.width,
                                             height: image.size.height,
                                             maxSize: maxSize)

        let font = UIFont.systemFont(ofSize: 16)
        let y = (font.capHeight - size.height) / 2
        attachment.bounds = CGRect(x: 0, y: y, width: size.width, height: size.height)

        return attachment
    }

    private func calculateProportionalSize(width: CGFloat, height: CGFloat, maxSize: CGFloat) -> CGSize {
        let aspectRatio = width / height

        if width > height {
            let newWidth = min(width, maxSize)
            let newHeight = newWidth / aspectRatio
            return CGSize(width: newWidth, height: newHeight)
        } else {
            let newHeight = min(height, maxSize)
            let newWidth = newHeight * aspectRatio
            return CGSize(width: newWidth, height: newHeight)
        }
    }

    private func updateCellLayout() {
        if let tableView = findTableView() {
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    private func configureLikes(for comment: CommentModel) {
        guard let likes = comment.likes else { return }

        let shouldShowCount = likes.userLikes > 0
        likesButton.configureDataSource(
            with: comment.isLiked ?? false,
            totalLikes: shouldShowCount ? likes.userLikes : 0
        )
    }

    private func configureDate(timestamp: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let now = Date()
        let dateFormatter = DateFormatter()

        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            mainDateLabel.text = "Today \(dateFormatter.string(from: date))"
        } else if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
            dateFormatter.dateFormat = "dd.MM HH:mm"
            mainDateLabel.text = dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            mainDateLabel.text = dateFormatter.string(from: date)
        }
    }

    private func findTableView() -> UITableView? {
        var view: UIView? = self
        while view != nil {
            if let tableView = view as? UITableView {
                return tableView
            }
            view = view?.superview
        }
        return nil
    }

    private func configureUI() {
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(mainDateLabel)
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(likesButton)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainDateLabel.leadingAnchor, constant: -8),

            mainDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            mainTextLabel.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 8),
            mainTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: likesButton.topAnchor, constant: -8),

            likesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likesButton.topAnchor.constraint(greaterThanOrEqualTo: mainTextLabel.bottomAnchor, constant: 8),
            likesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension CommentsFlowCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
