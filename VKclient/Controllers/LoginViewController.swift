//
//  ViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 16.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    private(set) lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        s.addGestureRecognizer(hideKeyboardGesture)
        
        return s
    }()
    
    private var loginView = LoginView()
    
    var safeArea: UILayoutGuide!

    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let navBar = navigationController?.navigationBar
        navBar?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationController?.navigationBar.isHidden = false
    }
    @objc func hideKeyboard() { self.scrollView.endEditing(true)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.configureUI()
    }
    
    override func loadView() {
        
        self.view = loginView
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "resul-mentes-DbwYNr8RPbg-unsplash")!)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let animation = CirleAnimation(circle1: self.circle1, circle2: self.circle2, circle3: self.circle3)
//        animation.animationLoading()
    }

    
    private func configureUI() {
//        self.setupLoginView()
        
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Error", message: "You are entered incorrect data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    private func setupLoginView() {
//        self.loginView.translatesAutoresizingMaskIntoConstraints = false
////        self.view.addSubview(loginView)
//
//        NSLayoutConstraint.activate([
//            loginView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
//            loginView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 5),
//            loginView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 5),
//            loginView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 5)
//        ])
//    }
    
//    private func addSubviews() {
//
////        self.view.addSubview(self.scrollView)
////        scrollView.addSubview(self.loginView)
//    }
    
//    private func setupConstraints() {
//        self.loginView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
////
////            scrollView.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
////            scrollView.widthAnchor.constraint(equalTo: loginView.widthAnchor),
////            scrollView.topAnchor.constraint(equalTo: loginView.topAnchor),
////            scrollView.bottomAnchor.constraint(equalTo: loginView.bottomAnchor),
//
//            loginView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            loginView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
//            loginView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
//            loginView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
//        ])
//
//
//    }
}
