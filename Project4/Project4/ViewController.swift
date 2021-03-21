import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  private var webView: WKWebView!
  private var progressView: UIProgressView!
  private var websites = ["hackingwithswift.com", "apple.com"]
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let url = URL(string: "https://" + websites[0])!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
  }
  
  @objc func openTapped() {
    let alertController = UIAlertController(title: "Open page..", message: nil, preferredStyle: .actionSheet)
    for website in websites {
      alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(alertController, animated: true)
  }
  
  @objc func openPage(_ action: UIAlertAction) {
    let url = URL(string: "https://" + action.title!)!
    webView.load(URLRequest(url: url))
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url
    
    if let host = url?.host {
      for website in websites {
        if host.contains(website) {
          decisionHandler(.allow)
          return
        }
      }
    }
    
    decisionHandler(.cancel)
    notify(blockedUrl: url)
  }
  
  private func notify(blockedUrl url: URL?) {
    guard let url = url, url.absoluteString != "about:blank" else { return }
    let alertController = UIAlertController(title: nil, message: "\(url.absoluteString) was blocked", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
  }
}

