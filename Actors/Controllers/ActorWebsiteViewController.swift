//
//  ActorWebsiteViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit
import WebKit

class ActorWebsiteViewController: UIViewController {
    
    // model data
    var actorName   : String!
    var actorWebsite: String!
    
    // views
    var webView          : WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        let isLastCharS = actorName.last == "s"
        title = actorName + (isLastCharS ? "' website" : "'s website")
        
        // adding activity indicator
        activityIndicator                  = UIActivityIndicatorView()
        activityIndicator.center           = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style            = .medium
        activityIndicator.startAnimating()

        navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: true)
        
        // configuring and loading the web view
        let webConfiguration = WKWebViewConfiguration()
        webView              = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webView.navigationDelegate = self
        webView.uiDelegate         = self
        
        webView.load(URLRequest(url: URL(string: actorWebsite)!))
        
        view = webView
    }
    
    private func showActivityIndicator(show: Bool) {
        
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK:- Web View Delegate

extension ActorWebsiteViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        showActivityIndicator(show: false)
    }
}
