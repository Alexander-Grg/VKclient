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

    private(set) lazy var loginEntryField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Login"
        text.font = .systemFont(ofSize: 17.0)
        text.textColor = .black
        text.textAlignment = .center
        text.backgroundColor = .white
        text.borderStyle = .roundedRect

        return text
    }()

    private(set) lazy var passwordEntryField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Password"
        text.font = .systemFont(ofSize: 17.0)
        text.textColor = .black
        text.textAlignment = .center
        text.isSecureTextEntry = true
        text.backgroundColor = .white
        text.borderStyle = .roundedRect

        return text
    }()

    private(set) lazy var enterActionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.gray()
        } else {
            // Fallback on earlier versions
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Enter", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
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
        self.addSubview(self.loginEntryField)
        self.addSubview(self.passwordEntryField)
        self.addSubview(self.enterActionButton)
        self.addSubview(self.appName)
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
            self.appName.bottomAnchor.constraint(equalTo: loginEntryField.topAnchor, constant: -50),
            self.loginEntryField.topAnchor.constraint(equalTo: self.appName.bottomAnchor),
            self.loginEntryField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.loginEntryField.widthAnchor.constraint(equalToConstant: 150),
            self.loginEntryField.heightAnchor.constraint(equalToConstant: 34),
            self.loginEntryField.bottomAnchor.constraint(equalTo: self.passwordEntryField.topAnchor, constant: -20),
            self.passwordEntryField.topAnchor.constraint(equalTo: self.loginEntryField.bottomAnchor),
            self.passwordEntryField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.passwordEntryField.widthAnchor.constraint(equalToConstant: 150),
            self.passwordEntryField.heightAnchor.constraint(equalToConstant: 34),
            self.passwordEntryField.bottomAnchor.constraint(equalTo: self.enterActionButton.topAnchor, constant: -20),
            self.enterActionButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.enterActionButton.topAnchor.constraint(equalTo: self.passwordEntryField.bottomAnchor),
            self.enterActionButton.widthAnchor.constraint(equalToConstant: 70),
            self.enterActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func buttonTap() {
        self.loginDelegate?.didTap(true)
    }
}
