//
//  SDWebViewController.swift
//  SaĝaDormo
//
//  Created by venus.janne on 2018/07/29.
//  Copyright © 2018 venus.janne. All rights reserved.
//

import UIKit
import WebKit

class SDWebViewController: SDViewController {
    
    @IBOutlet weak var contentView: UIView!
    fileprivate var webView: UIWebView!
    fileprivate var wkWebView: WKWebView!
    
    var url: String?
    var pageTitle: String?
    fileprivate let kErrorPageHtml: String = "error_page"
    
    class func openUrl(source: UIViewController, url: String, pageTitle: String? ) {
        /*
        if let inst = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.webController.identifier) as? SDWebViewController {
            inst.url = url
            inst.pageTitle = pageTitle
            inst.sourceViewController = source as? SDViewController
            
            source.navigationItem.title = ""
            source.tabBarController?.tabBar.isHidden = true

            source.navigationController?.show(inst, sender: source)
        }
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.pageTitle
        
        if #available(iOS 9, *) {
            self.wkWebView = WKWebView(frame: CGRect(x: 8, y: 0, width: self.view.frame.width - 16, height: self.view.frame.height))
            self.contentView.addSubview(self.wkWebView)
            self.contentView.adjustViewLayout(itemView: self.wkWebView)
            
            self.wkWebView.uiDelegate = self
            self.wkWebView.navigationDelegate = self
        } else {
            self.webView = UIWebView(frame: CGRect(x: 8, y: 0, width: self.view.frame.width - 16, height: self.view.frame.height))
            self.contentView.addSubview(self.webView)
            self.contentView.adjustViewLayout(itemView: self.webView)

            self.webView.backgroundColor = UIColor.white
            self.webView.delegate = self
        }

        self.myIndicator = UIActivityIndicatorView.setupIndicator(parentView: self.view)
        if let url = URL(string: self.url ?? "") {
            // check network connection
            /*if !SDAPIClient.verifyConnect(host: self.url ?? "") {
                SDMsgViewController.showError(sender: self, error:(NSURLErrorNotConnectedToInternet, nil, NSError(domain: "SaĝaDormo", code: NSURLErrorNotConnectedToInternet, userInfo: nil)), extra: nil)
                return
            }*/

            let request = URLRequest(url: url)
            if #available(iOS 9, *) {
                self.wkWebView.load(request)
            } else {
                self.webView.loadRequest(request)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.sourceViewController != nil {
            // タイトル設定
            self.sourceViewController?.resetNavigationItemTitle()
        }
        self.sourceViewController?.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setScrollDelegate(delegate: UIScrollViewDelegate?) {
        
    }
}

// MARK: - WKUIDelegate
extension SDWebViewController: WKUIDelegate {
    
}

// MARK: - WKNavigationDelegate
extension SDWebViewController:  WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.myIndicator.stopAnimatingEx(sender: nil)
        self.myIndicator.startAnimatingEx(sender: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.myIndicator.stopAnimatingEx(sender: nil)
        self._showErrorPage(error: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.myIndicator.stopAnimatingEx(sender: nil)
        self._showErrorPage(error: error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.myIndicator.stopAnimatingEx(sender: nil)
    }
    
    // エラー発生時のエラー表示
    //
    private func _showErrorPage(error: Error) {
        let htmlFilePath : String! = Bundle.main.path(forResource: self.kErrorPageHtml, ofType: "html")
        if var htmlString = try? String(contentsOfFile: htmlFilePath!) {
            
            // Strip url string
            var urlString: String!
            if #available(iOS 9, *) {
                urlString = self.wkWebView.url?.absoluteString ?? ""
            } else {
                urlString = (self.webView.request?.url?.absoluteString)!
            }
            urlString = (urlString == "") ? self.url : nil


            //ウェbページへのアクセス不可::ウェブページ(%@)は次の理由で読み込めませんでした\n%@
            let msgTmp: [String] = R.string.localeMisc.webErrorPageOfflineMessage(urlString ?? "", error.localizedDescription).components(separatedBy: "::")

            htmlString = htmlString.replacingOccurrences(of: "{{ErrorTitle}}", with: msgTmp[0])
            htmlString = htmlString.replacingOccurrences(of: "{{ErrorMessage}}", with: msgTmp[1])
            
            if #available(iOS 9, *) {
                self.wkWebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            } else {
                self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            }
        }
    }
}

// MARK: - UIWebViewDelegate

extension SDWebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.myIndicator.stopAnimatingEx(sender: nil)
        self.myIndicator.startAnimatingEx(sender: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.myIndicator.stopAnimatingEx(sender: nil)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.myIndicator.stopAnimatingEx(sender: nil)
        self._showErrorPage(error: error)
    }

}
