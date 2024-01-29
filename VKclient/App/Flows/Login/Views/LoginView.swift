//
//  LoginView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.05.2022.
//

import UIKit
import AuthenticationServices

final class LoginView: UIView {

    // MARK: - Properties

    private(set) lazy var wallpaper: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "resul-mentes-DbwYNr8RPbg-unsplash")
        image.sizeToFit()

        return image
    }()

    private(set) lazy var circle1: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "circle.fill")
        image.tintColor = .black
        image.clipsToBounds = true

        return image
    }()

    private(set) lazy var circle2: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "circle.fill")
        image.tintColor = .black
        image.clipsToBounds = true

        return image
    }()

    private(set) lazy var circle3: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "circle.fill")
        image.tintColor = .black
        image.clipsToBounds = true

        return image
    }()

    private(set) lazy var enterActionButton: UIButton = {
        var button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.configuration = .bordered()
        } else {
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        button.layer.cornerRadius = 4.0

        return button
    }()

    private(set) lazy var newUserActionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.gray()
        } else {
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("New here? Sign up!", for: .normal)
        button.addTarget(self, action: #selector(self.newUserButtonTap), for: .touchUpInside)
        button.layer.cornerRadius = 4.0

        return button
    }()

    private(set) lazy var appName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "VKclient"

        return label
    }()
    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5

        return stack
    }()
    weak var loginDelegate: LoginDelegate?
    weak var registrationDelegate: RegistrationDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        animateCircles()
    }

    // MARK: - setting UI
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
        self.animateCircles()
    }
    private func addSubviews() {
        self.addSubview(self.wallpaper)
        self.addSubview(self.appName)
        self.addSubview(self.enterActionButton)
        self.addSubview(self.newUserActionButton)
        self.addSubview(self.stackView)
        stackView.addArrangedSubview(self.circle1)
        stackView.addArrangedSubview(self.circle2)
        stackView.addArrangedSubview(self.circle3)
    }
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.wallpaper.topAnchor.constraint(equalTo: self.topAnchor),
            self.wallpaper.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.wallpaper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.wallpaper.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.appName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.appName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 150),
            self.enterActionButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.enterActionButton.topAnchor.constraint(equalTo: self.appName.bottomAnchor, constant: 50),
            self.newUserActionButton.centerXAnchor.constraint(equalTo: self.enterActionButton.centerXAnchor),
            self.newUserActionButton.topAnchor.constraint(equalTo: self.enterActionButton.bottomAnchor, constant: 25),
            self.stackView.centerXAnchor.constraint(equalTo: newUserActionButton.centerXAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.newUserActionButton.bottomAnchor, constant: 30),
            self.stackView.heightAnchor.constraint(equalToConstant: 20),
            self.stackView.widthAnchor.constraint(equalToConstant: 70)

        ])
    }

    private func animateCircles() {
        let animationDuration = 1.5

        circle1.alpha = 0.0
        circle2.alpha = 0.0
        circle3.alpha = 0.0

        UIView.animate(withDuration: animationDuration, delay: 0, options: [.repeat, .autoreverse]) {
            self.circle1.alpha = 1.0
        }

        UIView.animate(withDuration: animationDuration, delay: 0.5, options: [.repeat, .autoreverse]) {
            self.circle2.alpha = 1.0
        }

        UIView.animate(withDuration: animationDuration, delay: 1.0, options: [.repeat, .autoreverse]) {
            self.circle3.alpha = 1.0
        }
    }

    @objc func buttonTap() {
        self.loginDelegate?.didTap(true)
    }

    @objc func newUserButtonTap() {
        self.registrationDelegate?.didNewUserTap(true)
    }
}
