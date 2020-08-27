import UIKit
import CoreML
import Vision

final class HandleDetectedRectangles: UIView {

    fileprivate let remake = BoundsRemake()
    fileprivate let shapeLayer = RectangleShapeLayer()
    fileprivate let modelCheck = CheckModel()
    fileprivate var mlmodel: MLModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        
        self.mlmodel = modelCheck.model
        
        // чтобы можно было нажать на webView
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputImage(image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgimage = image.cgImage else { return }
        
        let requests = self.handleDetectedRectangles()
        
        let request = VNImageRequestHandler(cgImage: cgimage, orientation: orientation, options: [:])

        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try request.perform(requests)
            } catch let error as NSError {
                print("Failed to perform image request: \(error.localizedDescription)")
                return
            }
        }
    }

    fileprivate func handleDetectedRectangles() -> [VNCoreMLRequest] {
        guard let model = try? VNCoreMLModel(for: self.mlmodel)
            else { fatalError("VNCoreMLModel") }
        
        return [VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRecognizedObjectObservation]
                    else { return }
                
                CATransaction.begin()
                for result in results {
                    let rect = self.remake.rect(boundingBox: result.boundingBox, view: self)
                    let rectLayer = self.shapeLayer.painter(color: .systemBlue, rect: rect)

                    self.layer.addSublayer(rectLayer)

                    let limit = result.labels.count > 5 ? 1 : result.labels.count
                    for i in 0..<limit {
                        let identifier = result.labels[i].identifier
                        let confidence = results[i].confidence
                        print("detected: \(identifier)\n  – conf: \(confidence)\n  – pos: (x: \(Int(rect.minX)), y: \(Int(rect.minY)), width: \(Int(rect.maxX)), height: \(Int(rect.maxY)))\n", terminator: "\n")
                    }
                }
                CATransaction.commit()
            }
        })]
    }
}
