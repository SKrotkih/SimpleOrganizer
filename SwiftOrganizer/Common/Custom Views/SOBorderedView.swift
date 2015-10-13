import UIKit

@IBDesignable
class SOBorderedView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor()
    @IBInspectable var borderRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        layer.borderColor = borderColor.CGColor
        layer.borderWidth = self.borderWidth
        layer.masksToBounds = true
        layer.cornerRadius = borderRadius
    }
}
