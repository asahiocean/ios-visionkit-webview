import UIKit

class BoundsRemake {
    
    func boundingBox(bBox: CGRect, viewBounds: CGRect) -> CGRect {
        
        var reg = bBox
        
        let setWidth = viewBounds.width
        let setHeight = viewBounds.height
        //print("Set width while creating bounding box: \(setWidth)")
        //print("Set height while creating bounding box: \(setHeight)")
        
        reg.origin.x *= setWidth
        reg.origin.x += viewBounds.origin.x
        reg.origin.y = (1 - reg.origin.y) * setHeight + viewBounds.origin.y

        reg.size.width *= setWidth
        reg.size.height *= setHeight
        reg.origin.x -= 3
        reg.origin.y += 5
        reg.size.width += 10
        reg.size.height += 10
        //print("Rectangle: \(reg)")
        
        return reg
    }
}
