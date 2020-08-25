import UIKit
import WebKit
import CoreML
import Vision

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let modelURL = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc")!
    var pathLayer: CALayer? = CALayer()
    
    var testImage: UIImage? = nil {
        willSet {
            guard self.testImage == nil else { return }
            print("webView.takeSnapshot: ✅")
        }
        didSet {
            guard let image = testImage else { return }
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            guard let cgimage = image.cgImage else { return }
            
            let requests = handleDetectedRectangles()

            let imageRequestHandler = VNImageRequestHandler(
                cgImage: cgimage)

            DispatchQueue.main.async {
                do {
                    try imageRequestHandler.perform(requests)
                } catch let error as NSError {
                    print("Failed to perform image request: \(error)")
                    return
                }
            }

        }
    }
    
    fileprivate func handleDetectedRectangles() -> [VNCoreMLRequest] {
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { fatalError() }
        return [VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                guard let drawLayer = self.pathLayer,
                    let results = request.results as? [VNRecognizedObjectObservation]
                    else { return }
                
                CATransaction.begin()
                for result in results {
                    let rectBox = self.boundingBox(forRegionOfInterest: result.boundingBox, withinImageBounds: self.webView.bounds)
                    let rectLayer = self.shapeLayer(color: .blue, frame: rectBox)            // Add to pathLayer on top of image.
                    self.webView.layer.addSublayer(rectLayer)
                    
                    let len = result.labels.count > 5 ? 1 : result.labels.count
                    
                    for i in 0..<len {
                        let identifier = result.labels[i].identifier
                        let confidence = results[i].confidence
                                                
                        print("detected: \(identifier)\n  – conf: \(confidence)\n  – pos: (x: \(Int(rectBox.minX)), y: \(Int(rectBox.minY)), width: \(Int(rectBox.maxX)), height: \(Int(rectBox.maxY)))\n", terminator: "\n")
                    }
                }
                CATransaction.commit()
                drawLayer.setNeedsDisplay()
            }
        })]
    }
        
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
//        print("Image Width while creating bounding box",imageWidth)
//        print("Image height while creating bounding box",imageHeight)
        // Begin with input rect.
        var rect = forRegionOfInterest
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        rect.origin.x-=3
        rect.origin.y+=5
        rect.size.width+=10
        rect.size.height+=10
//        print("Rectangle bOUNDING BOX", rect)
        return rect
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        // Create a new layer.
//        print("Frame set to layer.frame", frame)
        let layer = CAShapeLayer()
        layer.name = "shapeLayer"
        
        // Configure layer's appearance.
        layer.fillColor = nil // No fill to show boxed object
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 3
        
        // Vary the line color according to input.
        layer.borderColor = color.cgColor
        
        // Locate the layer.
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        // Transform the layer to have same coordinate system as the imageView underneath it.
        layer.transform = CATransform3DMakeScale(1, -1, 1)
//        print("layer.frame after transform", layer.frame)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            layer.removeFromSuperlayer()
        }
        return layer
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
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
