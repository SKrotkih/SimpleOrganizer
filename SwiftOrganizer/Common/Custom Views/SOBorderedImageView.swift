import UIKit

@IBDesignable
class SOBorderedImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor()
    @IBInspectable var borderRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    
    var maskLayer: CAShapeLayer?
    var maskLayerRect = CGRect()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !CGRectEqualToRect(maskLayerRect, bounds) {
            maskLayer?.removeFromSuperlayer()
            maskLayer = nil
        }
        
        if maskLayer == nil {
            let outterPath = UIBezierPath(roundedRect: bounds, cornerRadius: borderRadius)
            let innerRect = CGRectInset(bounds, borderWidth, borderWidth)
            let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: borderRadius)
            outterPath.appendPath(innerPath)
            outterPath.usesEvenOddFillRule = true
            
            maskLayer = CAShapeLayer()
            maskLayer!.path = outterPath.CGPath
            maskLayer!.fillRule = kCAFillRuleEvenOdd;
            maskLayer!.fillColor = borderColor.CGColor
            maskLayer!.opacity = 1.0

            layer.cornerRadius = borderRadius
            layer.masksToBounds = true
            layer.addSublayer(maskLayer!)
            
            maskLayerRect = bounds
        }
    }
}