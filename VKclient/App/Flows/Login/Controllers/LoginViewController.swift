//
//  ViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 16.08.2021.
//

import UIKit

protocol LoginDelegate: AnyObject {
    func didTap(_ tap: Bool)
}

class LoginViewController: UIViewController {

    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)

        return scrollView
    }()

    private var window: UIWindow?
    private var appStartManager: AppStartManager?
    private var loginView = LoginView()

    var safeArea: UILayoutGuide!

    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        guard let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size
        else { return }
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

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
        loginView.loginDelegate = self
    }
    override func loadView() {
        self.view = loginView
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "resul-mentes-DbwYNr8RPbg-unsplash")!)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func showLoginError() {
        let alert = UIAlertController(title: "Error", message: "You are entered incorrect data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: LoginDelegate {

    func didTap(_ tap: Bool) {
        let nexVC = TabBarController()
        if tap == true {
            self.view.window?.rootViewController = nexVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
