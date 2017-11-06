import UIKit

extension UIView {
    
    func removeSubview(_ view: UIView?) {
        guard let view = view else { return }
        
        for constraint in constraints {
            if let first = constraint.firstItem as? UIView {
                if first == view {
                    removeConstraint(constraint)
                }
            }
            if let second = constraint.secondItem as? UIView {
                if second == view {
                    removeConstraint(constraint)
                }
            }
        }
        view.removeFromSuperview()
    }
    
    func pinToEdges(of superview: UIView, topOffset: CGFloat = 0, leftOffset: CGFloat = 0, bottomOffset: CGFloat = 0, rightOffset: CGFloat = 0) {
        
        topAnchor.constraint(equalTo: superview.topAnchor, constant: topOffset).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: leftOffset).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomOffset).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: rightOffset).isActive = true
    }
    
    func pinLeft(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        leftAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }
    
    func pinRight(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        rightAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }
    
    func pinRight(greaterThan anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        rightAnchor.constraint(greaterThanOrEqualTo: anchor).isActive = isActive
    }
    
    func pinTop(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }

    func pinBottom(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }
    
    func pinCenterX(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }
    
    func pinCenterY(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, isActive: Bool = true) {
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = isActive
    }
    
    func pinHeight(toConstant constant: CGFloat, isActive: Bool = true) {
        heightAnchor.constraint(equalToConstant: constant).isActive = isActive
    }
    
    func pinHeight(to anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, isActive: Bool = true) {
        heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).isActive = isActive
    }
    
    func pinWidth(to anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0, isActive: Bool = true) {
        widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).isActive = isActive
    }
    
    func pinWidth(toConstant constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(equalToConstant: constant).isActive = isActive
    }
    
    func pinWidth(greaterThan anchor: NSLayoutDimension, isActive: Bool = true) {
        widthAnchor.constraint(greaterThanOrEqualTo: anchor).isActive = isActive
    }
    
    func pinWidth(lessThan anchor: NSLayoutDimension, isActive: Bool = true) {
        widthAnchor.constraint(lessThanOrEqualTo: anchor).isActive = isActive
    }
    
    func pinWidth(lessThan constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = isActive
    }
    
    func pinWidth(greaterThan constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = isActive
    }
    
    func addBorder(to edge: UIRectEdge, color: UIColor = .lightGray) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch edge {
        case .top:
            border.frame = CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: 1
            )
        case .bottom:
            border.frame = CGRect(
                x: 0,
                y: frame.height - 1,
                width: frame.width,
                height: 1
            )
        case .left:
            border.frame = CGRect(
                x: 0,
                y: 0,
                width: 1,
                height: frame.height
            )
        case .right:
            border.frame = CGRect(
                x: frame.width - 1,
                y: 0,
                width: 1,
                height: frame.height
            )
        default: break
        }
        
        layer.addSublayer(border)
    }
}
