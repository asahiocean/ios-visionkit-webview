import UIKit

class RectangleShapeLayer {
    func painter(color: UIColor, frame: CGRect) -> CAShapeLayer {

        //print("Frame set to layer.frame", frame)
        let layer = CAShapeLayer()
        layer.name = "RectangleShapeLayer"
        
        layer.fillColor = nil
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 3
                
        layer.borderColor = color.cgColor
        
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        //print("layer.frame after transform", layer.frame)
        layer.setNeedsDisplay()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            layer.removeFromSuperlayer()
        }
        return layer
    }
}
