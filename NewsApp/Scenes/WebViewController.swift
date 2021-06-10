//
//  WebViewController.swift
//  NewsApp
//
//  Created by Akin O. on 6.06.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, Storyboarded {

    @IBOutlet var webView: WKWebView!

    var webURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "\(webURL!)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
