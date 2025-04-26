//
//  VKLoginController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 02.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
@preconcurrency import WebKit
import KeychainAccess

final class VKLoginController: UIViewController, WKUIDelegate {
    private(set) lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        loadWebView()
        }


    func loadWebView() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7965892"),
            URLQueryItem(name: "scope", value: "friends, photos, wall, groups, video"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]

        let request = URLRequest(url: components.url!)
            self.webView.load(request)
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}
extension VKLoginController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy)
                 -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else { decisionHandler(.allow); return }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        print(params)
        guard let token = params["access_token"],
              let userIdString = params["user_id"],
              Int(userIdString) != nil else {
            decisionHandler(.allow)
            return
        }
        let keychain = Keychain()

        
        do {
           try keychain.set(token, key: "token")
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }

        let next = TabBarController()
        self.view.window?.rootViewController = next
        self.view.window?.makeKeyAndVisible()

        decisionHandler(.cancel)
    }

}
