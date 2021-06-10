import UIKit

class RemakeBounds {
    internal func boundingBox(bBox: CGRect, bounds: CGRect) -> CGRect {
        
        var rect = bBox
        
        let width = bounds.width
        let height = bounds.height
        
        //print("Width while creating bounding box", width)
        //print("Height while creating bounding box", height)

        rect.origin.x *= width
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * height + bounds.origin.y
        
        rect.size.width *= width
        rect.size.height *= height
        rect.origin.x -= 3
        rect.origin.y += 5
        rect.size.width += 10
        rect.size.height += 10
        
        //print("Rectangle bOUNDING BOX", rect)
    
    return rect
    }
}
