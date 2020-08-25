import Foundation
import WebKit

extension WKWebView {
    public func loader(_ urlString: String) {
        if let url = URL.fixHttps(urlString) {
            let request = URLRequest(url: url)
                self.addObserver(self,
                    forKeyPath: #keyPath(WKWebView.estimatedProgress),
                    options: .new, context: nil)
            
                self.addObserver(self,
                    forKeyPath: #keyPath(WKWebView.title),
                    options: .new, context: nil)
                
                self.allowsBackForwardNavigationGestures = true
                self.load(request)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            let value = String(format: "%.1f", estimatedProgress * 100)
            print("Progress: \(value)%")
        }
        
        if keyPath == "title" {
            if let title = self.title {
                guard title.isEmpty == false else { return }
                print("Site title: \(title)")
            }
        }
    }
}
