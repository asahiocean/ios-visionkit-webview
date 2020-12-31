import UIKit
import Vision

extension HandleDetectedRectangles {
    func handleDetectedRectangles() -> [VNCoreMLRequest] {
        guard let model = try? VNCoreMLModel(for: self.mlmodel) else { fatalError("VNCoreMLModel") }
        
        return [VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                guard let results = request.results as? [VNRecognizedObjectObservation]
                else { return }
                
                CATransaction.begin()
                for result in results {
                    let rect = self.remake.rect(boundingBox: result.boundingBox, view: self)
                    let rectLayer = self.shapeLayer.painter(color: .systemBlue, rect: rect, text: result.labels.first!.identifier)
                    
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
