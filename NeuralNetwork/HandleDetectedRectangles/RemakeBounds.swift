import UIKit

class BoundsRemake {
    func rect(boundingBox: CGRect, view: UIView) -> CGRect {
        
        var rect = boundingBox
        
        let frame = view.frame
        let width = frame.width
        let height = frame.height
        //print("Set width while creating bounding box: \(width)")
        //print("Set height while creating bounding box: \(height)")
        
        rect.origin.x *= width + frame.origin.x
        rect.origin.y = (1 - rect.origin.y) * height

        rect.size.width *= width
        rect.size.height *= height
        rect.origin.x -= 0
        rect.origin.y -= 0
        rect.size.width += 0
        rect.size.height += 0
        
        //print("Rectangle: \(rect)")
        
        return rect
    }
}
