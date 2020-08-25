import UIKit
import WebKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var rectView: HandleDetectedRectangles!
    var webView: Web!
    
    override func loadView() {
        super.loadView()
        self.webView = Web(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.bounds.height - 50))
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rectView = HandleDetectedRectangles(frame: self.webView.frame)
        self.view.addSubview(webView)
        self.view.addSubview(self.rectView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Did End On Exit
    @IBAction func changeURL(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.webView.loader(text)
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
extension ViewController {
    func landmark(points: [CGPoint]?, to rect: CGRect) -> [CGPoint]? {
      guard let points = points else {
        return nil
      }

      return points
    }
    func convert(rect: CGRect) -> CGRect {
        return CGRect(origin: rect.origin, size: rect.size)
    }
}

class Web: WKWebView {
    let searchBar = UITextField()
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.backgroundColor = .systemRed
        self.addSubview(searchBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
