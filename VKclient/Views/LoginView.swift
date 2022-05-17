//
//  LoginView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.05.2022.
//

import UIKit
import AuthenticationServices

final class LoginView: UIView {
    
//    MARK: - Properties
    
    private(set) lazy var wallpaper: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = UIImage(named: "resul-mentes-DbwYNr8RPbg-unsplash")
        i.sizeToFit()
        
        return i
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
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Login"
        t.font = .systemFont(ofSize: 17.0)
        t.textColor = .black
        t.textAlignment = .center
        t.backgroundColor = .white
        t.borderStyle = .roundedRect
        
        return t
    }()
    
    private(set) lazy var passwordEntryField: UITextField = {
        let t = UITextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Password"
        t.font = .systemFont(ofSize: 17.0)
        t.textColor = .black
        t.textAlignment = .center
        t.isSecureTextEntry = true
        t.backgroundColor = .white
        t.borderStyle = .roundedRect
        
        return t
    }()
    
    private(set) lazy var EnterActionButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            b.configuration = UIButton.Configuration.gray()
        } else {
            // Fallback on earlier versions
        }
        b.setTitleColor(UIColor.black, for: .normal)
        b.setTitle("Enter", for: .normal)
        b.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        b.layer.cornerRadius = 4.0
        
        return b
    }()
    
    private(set) lazy var appName: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 36.0)
        l.textColor = .black
        l.textAlignment = .center
        l.text = "VKclient"
        
        return l
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 10
        s.addArrangedSubview(self.circle1)
        s.addArrangedSubview(self.circle2)
        s.addArrangedSubview(self.circle3)
        
        return s
    }()
    
    let VC = LoginViewController()
    
//    MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
 
//    MARK: - setting UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(self.wallpaper)
//        self.addSubview(self.circle1)
//        self.addSubview(self.circle2)
//        self.addSubview(self.circle3)
        self.addSubview(self.loginEntryField)
        self.addSubview(self.passwordEntryField)
        self.addSubview(self.EnterActionButton)
        self.addSubview(self.appName)
//        self.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        
        let s = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            self.wallpaper.topAnchor.constraint(equalTo: self.topAnchor),
            self.wallpaper.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.wallpaper.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.wallpaper.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.appName.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            self.appName.topAnchor.constraint(equalTo: s.topAnchor, constant: 150),
            self.appName.bottomAnchor.constraint(equalTo: loginEntryField.topAnchor, constant: -50),


            self.loginEntryField.topAnchor.constraint(equalTo: self.appName.bottomAnchor),
            self.loginEntryField.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            self.loginEntryField.widthAnchor.constraint(equalToConstant: 150),
            self.loginEntryField.heightAnchor.constraint(equalToConstant: 34),
            self.loginEntryField.bottomAnchor.constraint(equalTo: self.passwordEntryField.topAnchor, constant: -20),
            
            self.passwordEntryField.topAnchor.constraint(equalTo: self.loginEntryField.bottomAnchor),
            self.passwordEntryField.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            self.passwordEntryField.widthAnchor.constraint(equalToConstant: 150),
            self.passwordEntryField.heightAnchor.constraint(equalToConstant: 34),
            self.passwordEntryField.bottomAnchor.constraint(equalTo: self.EnterActionButton.topAnchor, constant: -20),

//            self.stackView.topAnchor.constraint(equalTo: self.passwordEntryField.bottomAnchor),
//            self.stackView.centerXAnchor.constraint(equalTo: s.centerXAnchor),
//            self.stackView.heightAnchor.constraint(equalToConstant: 34),
//            self.stackView.widthAnchor.constraint(equalToConstant: 150)
//            self.stackView.leadingAnchor.constraint(equalTo: s.leadingAnchor, constant: 135),
//            self.stackView.trailingAnchor.constraint(equalTo: s.trailingAnchor, constant: 135),
//            self.stackView.bottomAnchor.constraint(equalTo: self.EnterActionButton.topAnchor, constant: 8),
//
            self.EnterActionButton.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            self.EnterActionButton.topAnchor.constraint(equalTo: self.passwordEntryField.bottomAnchor),
            self.EnterActionButton.widthAnchor.constraint(equalToConstant: 70),
            self.EnterActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let checkResult = checkUserData()
//
//        if !checkResult {
//            VC.showLoginError()
//        }
//        return checkResult
//    }
    func checkUserData() -> Bool {
        guard let login = loginEntryField.text,
              let password = passwordEntryField.text else { return false }
        
                if login == "a" && password == "1" {
        return true
                } else {
                    return false
                }
    }
    
    @objc func buttonTap() {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let nextVC = storyBoard.instantiateViewController(withIdentifier: "TabBar")
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

