import UIKit

extension UIImage {

    // create image of solid color
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextFillRect(ctx, CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


