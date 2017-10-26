import UIKit

extension UIView {
    
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
    
    func pinWidth(toConstant constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(equalToConstant: constant).isActive = isActive
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
