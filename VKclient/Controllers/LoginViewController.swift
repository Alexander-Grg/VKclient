//
//  ViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 16.08.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var circle1: UIImageView!
    @IBOutlet var circle2: UIImageView!
    @IBOutlet var circle3: UIImageView!
    @IBOutlet var loginEntryField: UITextField!
    @IBOutlet weak var passwordEntryField: UITextField!
    @IBAction func EnterActionButton(_ sender: Any) {}
    @IBOutlet var scrollView: UIScrollView!
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {}
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
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
    @objc func hideKeyboard() { self.scrollView?.endEditing(true)}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationLoading1()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        func animationLoading1() {
            
            self.circle1.alpha = 0
            self.circle2.alpha = 0
            self.circle3.alpha = 0
            
            UIView.animateKeyframes(withDuration: 7,
                                    delay: 0,
                                    options: [.repeat, .autoreverse],
                                    animations: {
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 0.5,
                                   animations: { self.circle1.alpha = 1})
                UIView.addKeyframe(withRelativeStartTime: 0.33,
                                   relativeDuration: 0.5,
                                   animations: { self.circle2.alpha = 1})
                UIView.addKeyframe(withRelativeStartTime: 0.66,
                                   relativeDuration: 0.5,
                                   animations: { self.circle3.alpha = 1})
            },
                                    completion: nil)
        }
        
        //        func animationLoading1() {
        //            UIView.animateKeyframes(withDuration: 3,
        //                                    delay: 0,
        //                                    options: [.repeat, .autoreverse],
        //                                    animations: {
        //                UIView.addKeyframe(withRelativeStartTime: 0,
        //                                   relativeDuration: 0.33,
        //                                   animations: { self.circle1.alpha = 1 })
        //                UIView.addKeyframe(withRelativeStartTime: 0.33,
        //                                   relativeDuration: 0.33,
        //                                   animations: { self.circle2.alpha = 1 })
        //                UIView.addKeyframe(withRelativeStartTime: 0.66,
        //                                   relativeDuration: 0.33,
        //                                   animations: { self.circle3.alpha = 1 })
        //            })
        //        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
        return checkResult
    }
    func checkUserData() -> Bool {
        //        guard let login = loginEntryField.text,
        //              let password = passwordEntryField.text else { return false }
        //
        //        if login == "admin" && password == "1234" {
        return true
        //        } else {
        //            return false
        //        }
    }
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены некорректные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


