import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var viewRect: HandleDetectedRectangles!
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        viewRect = HandleDetectedRectangles(frame: webView.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(viewRect)
    }
    
    // Did End On Exit
    @IBAction func changeURL(_ sender: UITextField) {
        guard let text = sender.text else { return }
        webView.loader(text)
    }
    
    @IBAction func backButtonPress(_ sender: UIBarButtonItem) {
        webView.stopLoading(); webView.goBack()
    }
    
    @IBAction func forwardButtonPress(_ sender: UIBarButtonItem) {
        webView.stopLoading(); webView.goForward()
    }
    
    @IBAction func refreshButtonPress(_ sender: UIBarButtonItem) {
        webView.reload()
    }
}
