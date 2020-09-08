import UIKit

class RectangleShapeLayer {
    func painter(color: UIColor, rect: CGRect, text: String) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let myTextLayer = CATextLayer()
        
        layer.name = "RectangleShapeLayer"
        
        layer.fillColor = .none
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 3
                
        layer.borderColor = color.cgColor
        
        layer.anchorPoint = .zero
        layer.frame = rect
        
        layer.masksToBounds = true
        
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        layer.setNeedsDisplay()

        myTextLayer.string = text
        myTextLayer.backgroundColor = UIColor.blue.cgColor
        myTextLayer.foregroundColor = UIColor.cyan.cgColor
        myTextLayer.frame = rect
        layer.addSublayer(myTextLayer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            layer.removeFromSuperlayer()
        }
        
        return layer
    }
}
