import UIKit

class BoundsRemake {
    func rect(boundingBox: CGRect, view: UIView) -> CGRect {
        
        var rect = boundingBox
        
        let frame = view.frame
        let width = frame.width
        let height = frame.height
        //print("Set width while creating bounding box: \(width)")
        //print("Set height while creating bounding box: \(height)")
        
        rect.origin.x *= width
        rect.origin.x += frame.origin.x
        rect.origin.y = (1 - rect.origin.y) * height + frame.origin.y

        rect.size.width *= width
        rect.size.height *= height
        rect.origin.x -= 2.5
        rect.origin.y += 5
        rect.size.width += 10
        rect.size.height += 10
        //print("Rectangle: \(rect)")
        
        return rect
    }
}
