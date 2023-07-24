//
//  WebViewViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 24.07.2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    private var webView: WKWebView!
    
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.urlString = ""
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func makeUI() {
        webView = WKWebView()
        webView.frame = UIScreen.main.bounds
        view.addSubview(webView)
    }
}

