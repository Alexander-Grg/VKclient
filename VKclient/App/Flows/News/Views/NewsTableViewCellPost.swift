//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit

protocol NewsDelegate: AnyObject {
    func buttonTapped(cell: NewsTableViewCellPost)
}

final class NewsTableViewCellPost: UITableViewCell {

    // MARK: - Properties
    var isPressed: Bool = false
    weak var delegate: NewsDelegate?

    private(set) lazy var textForPost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        label.contentMode = .scaleToFill
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()

    private(set) lazy var showMoreTextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Configuring UI

    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.contentView.addSubview(self.showMoreTextButton)
        self.contentView.addSubview(self.textForPost)
    }

    @objc private func buttonTap() {
        showMoreTextButton.setTitle(buttonStateName(), for: .normal)
        delegate?.buttonTapped(cell: self)
    }

    private func setupConstraints() {
        self.selectionStyle = .none
        textForPost.translatesAutoresizingMaskIntoConstraints = false
        showMoreTextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textForPost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textForPost.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            textForPost.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),

            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
            showMoreTextButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10),
            showMoreTextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)
        ])
    }

    // MARK: - Configuring cell

    func configureCell(_ postText: News, isTapped: Bool, isButtonPressed: Bool) {
        textForPost.text = postText.text
        if isTapped {
            self.isPressed = isButtonPressed
            showMoreTextButton.setTitle(self.buttonStateName(), for: .normal)
            showMoreTextButton.isHidden = false
        } else {
            showMoreTextButton.isHidden = true
        }
    }

    private func buttonStateName() -> String {
        isPressed ? "Show Less": "Show More"
    }
}

extension NewsTableViewCellPost: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
