import UIKit

class BoundsRemake {
    func rect(boundingBox: CGRect, view: UIView) -> CGRect {
        
        var rect = boundingBox
        
        let width = view.frame.width
        let height = view.frame.height
        //print("Set width while creating bounding box: \(width)")
        //print("Set height while creating bounding box: \(height)")
        
        rect.origin.x *= width
        rect.origin.x += view.frame.origin.x
        rect.origin.y = (1 - rect.origin.y) * height + view.frame.origin.y

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
