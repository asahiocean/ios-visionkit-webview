import UIKit
import CoreML
import Vision

final class HandleDetectedRectangles: UIView {
    internal let shapeLayer = RectangleShapeLayer()
    internal let modelCheck = CheckModel()
    internal let remake = BoundsRemake()
    internal var mlmodel: MLModel!
    
    fileprivate let requestDispatch = DispatchQueue(label: "request.DispatchQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.masksToBounds = true
                
        self.mlmodel = modelCheck.model
        
        // чтобы можно было нажать на webView
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func inputImage(image: UIImage) {
        let orient = CGImagePropertyOrientation(image.imageOrientation)
        guard let cgimage = image.cgImage else { return }
        
        let requests = self.handleDetectedRectangles()
        
        let request = VNImageRequestHandler(cgImage: cgimage, orientation: orient, options: [:])

        requestDispatch.async {
            do {
                try request.perform(requests)
            } catch let error as NSError {
                print("Failed to perform image request: \(error.localizedDescription)")
                return
            }
        }
    }
}
