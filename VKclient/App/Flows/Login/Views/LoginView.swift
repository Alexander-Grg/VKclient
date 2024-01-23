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
        image.image = UIImage(named: "circle.fill")
        image.tintColor = .systemTeal
        image.clipsToBounds = true

        return image
    }()

    private(set) lazy var circle2: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "circle.fill")
        image.tintColor = .systemTeal
        image.clipsToBounds = true

        return image
    }()

    private(set) lazy var circle3: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "circle.fill")
        image.tintColor = .systemTeal
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
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.addArrangedSubview(self.circle1)
        stack.addArrangedSubview(self.circle2)
        stack.addArrangedSubview(self.circle3)

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
    // MARK: - setting UI
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    private func addSubviews() {
        self.addSubview(self.wallpaper)
        self.addSubview(self.stackView)
        self.addSubview(self.appName)
        self.addSubview(self.enterActionButton)
        self.addSubview(self.newUserActionButton)
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
            self.stackView.centerXAnchor.constraint(equalTo: self.newUserActionButton.centerXAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.newUserActionButton.bottomAnchor, constant: 20)

        ])
    }
    @objc func buttonTap() {
        self.loginDelegate?.didTap(true)
    }

    @objc func newUserButtonTap() {
        self.registrationDelegate?.didNewUserTap(true)
    }
}
