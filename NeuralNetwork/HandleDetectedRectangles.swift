import UIKit
import CoreML
import Vision

final class HandleDetectedRectangles: UIView {
    
    fileprivate let boundsRemake = BoundsRemake()
    fileprivate var model: URL?
    
    var image: UIImage? = nil {
        
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // чтобы пропускать нажатия в браузер
        self.isUserInteractionEnabled = false
        
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc")
            else { fatalError("Can't find path to modelURL!!!") }

        if modelURL.absoluteString.isEmpty {
            self.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.07843137255, blue: 0.2352941176, alpha: 0.7524882277)
        } else {
            self.model = modelURL
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
        
    func imageInput(_ img: UIImage) {
        guard let cgimage = img.cgImage else { return }
        
        let requests = self.handleDetectedRectangles()

        let imageRequestHandler = VNImageRequestHandler(cgImage: cgimage)

        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try imageRequestHandler.perform(requests)
            } catch let error as NSError {
                print("🛑 Failed to perform image request: \(error.localizedDescription)")
                return
            }
        }
    }
    
    fileprivate func handleDetectedRectangles() -> [VNCoreMLRequest] {
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: self.model!)) else { fatalError("Check target: modelURL") }
        
        return [VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRecognizedObjectObservation]
                    else { return }
                
                CATransaction.begin()
                for result in results {
                    let limit = result.labels.count > 5 ? 1 : result.labels.count
                    
                    for i in 0..<limit {
                        let rectBox = self.boundsRemake.boundingBox(bBox: results[i].boundingBox, viewBounds: self.bounds)
                        
                        let rectLayer = self.shapeLayer(color: .blue, frame: rectBox)
                                            
                        self.layer.addSublayer(rectLayer)
                        
                        let identifier = result.labels[i].identifier
                        let confidence = results[i].confidence
                                                
                        print("detected: \(identifier)\n  – conf: \(confidence)\n  – pos: (x: \(Int(rectBox.minX)), y: \(Int(rectBox.minY)), width: \(Int(rectBox.maxX)), height: \(Int(rectBox.maxY)))\n", terminator: "\n")
                    }
                }
                CATransaction.commit()
            }
        })]
    }
        
    func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {

        //print("Frame set to layer.frame", frame)
        
        let layer = CAShapeLayer()
        layer.name = "shapeLayer"

        layer.fillColor = nil // No fill to show boxed object
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 3
            
        layer.borderColor = color.cgColor
        
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            layer.removeFromSuperlayer()
        }
        return layer
    }

}
