//
//  OfficialWebsiteViewController.swift
//  考证
//
//  Created by 周梓康 on 2018/11/29.
//  Copyright © 2018 周梓康. All rights reserved.
//

import UIKit
import WebKit

class OfficialWebsiteViewController: UIViewController {

    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var webView=WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints=false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        webView.layer.zPosition = -1
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: URL(string: "http://www.sac.net.cn/")!))
        indicator.hidesWhenStopped = true
    }
    
    @IBAction func doRefresh(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func doStop(_ sender: UIBarButtonItem) {
        webView.stopLoading()
    }
    
    @IBAction func doBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func doForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OfficialWebsiteViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
