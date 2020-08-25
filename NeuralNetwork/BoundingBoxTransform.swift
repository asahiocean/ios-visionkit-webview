import UIKit

class BoundsRemake {
    func reform(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
            
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        //print("Image Width while creating bounding box",imageWidth)
        //print("Image height while creating bounding box",imageHeight)
        
        var rect = forRegionOfInterest

        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y

        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        rect.origin.x-=3
        rect.origin.y+=5
        rect.size.width+=10
        rect.size.height+=10
        //print("Rectangle bOUNDING BOX", rect)
        
        return rect
    }
}
