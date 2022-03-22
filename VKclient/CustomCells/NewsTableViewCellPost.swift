//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit
import SwiftUI


//protocol NewsDelegate {
//    func buttonTapped(cell: NewsTableViewCellPost)
//}
//
//class NewsTableViewCellPost: UITableViewCell {
//
//    //    MARK: - Properties
//
//    let textForPost = UILabel()
//    let showMoreTextButton = UIButton()
//    static let reusedIdentifier = "NewsPostCell"
//    var isPressed: Bool = false
//    var delegate: NewsDelegate?
//
//    //    MARK: - Lifecycle
//
////    override func awakeFromNib() {
////        super.awakeFromNib()
////        self.configureUI()
////    }
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//          super.init(style: style, reuseIdentifier: reuseIdentifier)
//          self.configureUI()
//
//
//      }
//
//      required init?(coder aDecoder: NSCoder) {
//          super.init(coder: aDecoder)
//          self.configureUI()
//
//      }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    //    MARK: - Configuring UI
//
//    private func configureUI() {
//        self.addTextLabel()
//        self.addShowMoreButton()
//        self.setupConstraints()
//        self.buttonGesture(button: showMoreTextButton.self)
//    }
//
//    private func addTextLabel() {
//        self.textForPost.translatesAutoresizingMaskIntoConstraints = false
//        textForPost.font = UIFont.systemFont(ofSize: 16.0)
//        textForPost.textColor = .black
//        textForPost.lineBreakMode = .byClipping
//        textForPost.contentMode = .scaleToFill
//        textForPost.numberOfLines = 0
//        textForPost.textAlignment = .center
//        textForPost.sizeToFit()
//
//
//        self.addSubview(self.textForPost)
//    }
//
//    private func addShowMoreButton() {
//        self.showMoreTextButton.translatesAutoresizingMaskIntoConstraints = false
//        showMoreTextButton.setTitleColor(UIColor.systemBlue, for: .normal)
//
////        showMoreTextButton.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
//        self.addSubview(self.showMoreTextButton)
//    }
//
//    private func buttonGesture(button: UIButton) {
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonTap))
//        recognizer.numberOfTapsRequired = 1
//        recognizer.numberOfTouchesRequired = 1
//        showMoreTextButton.addGestureRecognizer(recognizer)
//        showMoreTextButton.isUserInteractionEnabled = true
//    }
//
//    @objc func buttonTap(_ sender: Any?) {
//        if sender is UIButton {
//            isPressed = !isPressed
//            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
//        }
//        delegate?.buttonTapped(cell: self)
//    }
//    private func setupConstraints() {
//
//        NSLayoutConstraint.activate([
//
//            textForPost.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
//            textForPost.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
//            textForPost.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 10),
//            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),
//
//            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
//            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
//            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
//            showMoreTextButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 10),
//            showMoreTextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5)
//        ])
//    }
//
//    //    MARK: - Configuring cell
//
//    func configure(_ postText: PostNews, isTapped: Bool) {
//        textForPost.text = postText.text
//        if isTapped {
//            isPressed = false
//            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
//            showMoreTextButton.isHidden = false
//        } else {
//            showMoreTextButton.isHidden = true
//        }
//    }
//
//    private func buttonStateName() -> String {
//        isPressed ? "Show Less": "Show More"
//    }
//
//    }

protocol NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost)
}

class NewsTableViewCellPost: UITableViewCell {

    //    MARK: - Properties



    static let reusedIdentifier = "NewsPostCell"
    var isPressed: Bool = false
    var delegate: NewsDelegate?

    private let textForPost: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .black
        l.lineBreakMode = .byClipping
        l.contentMode = .scaleToFill
        l.numberOfLines = 0
        l.textAlignment = .left
        l.sizeToFit()

        return l
    }()

    private let showMoreTextButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(UIColor.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(buttonTap(_:)) , for: .touchUpInside)
        b.isUserInteractionEnabled = true

        return b

    }()

    //    MARK: - Lifecycle

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

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.textForPost.text = nil
//    }

    //    MARK: - Configuring UI

    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
//        self.addTapp()
        self.isUserInteractionEnabled = true
    }

    private func addSubviews() {
        self.addSubview(self.showMoreTextButton)
        self.addSubview(self.textForPost)
    }

//    func addTapp() {
//        showMoreTextButton.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
//
//    }

    @objc func buttonTap(_ sender: Any?) {
        if sender is UIButton {
            isPressed = !isPressed
            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
        }
        delegate?.buttonTapped(cell: self)
    }

    private func setupConstraints() {

        let s = safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            textForPost.topAnchor.constraint(equalTo: s.topAnchor, constant: 10),
            textForPost.leftAnchor.constraint(equalTo: s.leftAnchor, constant: 10),
            textForPost.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 10),
            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),

            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
            showMoreTextButton.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 10),
            showMoreTextButton.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5)
        ])
    }

    //    MARK: - Configuring cell

    func configureCell(_ postText: PostNews, isTapped: Bool) {
        textForPost.text = postText.text
        if isTapped {
            isPressed = false
            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
            showMoreTextButton.isHidden = false
        } else {
            showMoreTextButton.isHidden = true
        }
    }

    private func buttonStateName() -> String {
        isPressed ? "Show Less": "Show More"
    }

    }

