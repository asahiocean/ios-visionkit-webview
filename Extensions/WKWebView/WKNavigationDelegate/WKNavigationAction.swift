import Foundation
import WebKit
import Vision

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                
        if let url = webView.url {
            self.addressBar.text = url.absoluteString
        }
        
        let displayLink = CADisplayLink(
                target: self,
                selector: #selector(self.snapshoter))
            displayLink.preferredFramesPerSecond = 5
        displayLink.add(to: .main, forMode: .default)
    }
    @objc fileprivate func snapshoter() {
        self.webView.takeSnapshot(with: nil) { image, error in
            guard let image = image, error == nil else { return }
            //print("Snapshot -- \(Date())")
            self.testImage = image
        }
    }
}
