//
//  VKLoginController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import UIKit
import WebKit

class VKLoginController: UIViewController, WKUIDelegate {

    private(set) lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()

    private var window: UIWindow?
    private var appStartManager: AppStartManager?

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
            URLQueryItem(name: "scope", value: "friends, photos, wall, groups"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]

        let request = URLRequest(url: components.url!)
        webView.load(request)
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

        Session.instance.token = token

        let next = LoginViewController()
        self.navigationController?.pushViewController(next, animated: true)

        decisionHandler(.cancel)
    }
}
