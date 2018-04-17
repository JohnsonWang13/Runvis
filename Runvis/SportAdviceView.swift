
import UIKit

class SportAdviceView: UIView {
    
    override func layoutSubviews() {
        
        self.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.shadowOffset  = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 4
        
        self.layer.cornerRadius  = 4
    }
}

class AirLevelColor: UIView {
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = 4
    }
}

class AriLevelColorSmall: UIView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

extension CALayer {
    
    func roundCorner(_ corners: UIRectCorner, radius: CGFloat) {
        
        let viewFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        let path = UIBezierPath(roundedRect: viewFrame, byRoundingCorners: [corners], cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.mask = maskLayer
    }
}
