//
//  ViewController.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 23.03.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit
import WebKit

class VKLoginVC: UIViewController {
    
    let session = SessionManager.instance
    
    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loginRequest = URLComponents()
        
        loginRequest.scheme = "https"
        loginRequest.host = "oauth.vk.com"
        loginRequest.path = "/authorize"
        loginRequest.queryItems = [
            URLQueryItem(name: "client_id", value: "6704883"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,offline,groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.85")
        ]
        let request = URLRequest(url: loginRequest.url!)
        webView.load(request)
        
    }
}

extension VKLoginVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
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
        
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        print("Token: \(token)", "UserID: \(userId)")
        session.token = token
        session.userid = userId
        
        performSegue(withIdentifier: "loginSigue", sender: nil)
        
        decisionHandler(.cancel)
    }
}

