import UIKit
import UICircularProgressRing

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
    
    func pinHeight(to constant: CGFloat, isActive: Bool = true) {
        heightAnchor.constraint(equalToConstant: constant).isActive = isActive
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
    
    func pinWidth(to constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(equalToConstant: constant).isActive = isActive
    }
    
    func pinWidth(toConstant constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(equalToConstant: constant).isActive = isActive
    }
    
    func pinWidth(greaterThan anchor: NSLayoutDimension, multiplier: CGFloat = 1, isActive: Bool = true) {
        widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier).isActive = isActive
    }
    
    func pinWidth(lessThan anchor: NSLayoutDimension, multiplier: CGFloat = 1, isActive: Bool = true) {
        widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier).isActive = isActive
    }
    
    func pinWidth(lessThan constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = isActive
    }
    
    func pinWidth(greaterThan constant: CGFloat, isActive: Bool = true) {
        widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = isActive
    }
    
    func addOutline(color: UIColor = .altBg, thickness: CGFloat = 1) {
        layer.borderWidth = thickness
        layer.borderColor = color.cgColor
    }
    
    func removeOutline() {
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
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
    
    var loadingViewTag: Int { return 666 }
    var progressBarTag: Int { return 667 }
    var blurViewTag: Int { return 668 }
    var progressBar: UICircularProgressRing {
        let progressBar = UICircularProgressRing()
        progressBar.tag = progressBarTag
        progressBar.style = .bordered(width: 3, color: .main)
        progressBar.innerRingColor = .main
        progressBar.maxValue = 100
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }
    var blurView : UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        view.tag = blurViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    var loadingView: UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.tag = loadingViewTag
        view.translatesAutoresizingMaskIntoConstraints = false
        let blur = blurView
        let bar = progressBar
        [blur, bar].forEach { view.addSubview($0) }
        blur.pinToEdges(of: view)
        bar.pinCenterX(to: view.centerXAnchor)
        bar.pinCenterY(to: view.centerYAnchor)
        bar.pinHeight(toConstant: 100)
        bar.pinWidth(to: bar.heightAnchor)
        return view
    }
    
    func setProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            if let sself = self,
                let bar = sself.viewWithTag(sself.progressBarTag) as? UICircularProgressRing {
                bar.startProgress(to: CGFloat(progress * 100), duration: 0.2)
            }
        }
    }
    
    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if let sself = self {
                if loading {
                    let newLoadingView = sself.loadingView
                    sself.insertSubview(newLoadingView, at: 999)
                    newLoadingView.pinToEdges(of: sself)
                    sself.layoutIfNeeded()
                } else {
                    let oldLoadingView = sself.viewWithTag(sself.loadingViewTag)
                    let blur = sself.viewWithTag(sself.blurViewTag) as? UIVisualEffectView
                    UIView.animate(withDuration: 0.3, animations: {
                        blur?.effect = nil
                        oldLoadingView?.alpha = 0
                    }) { _ in
                        oldLoadingView?.removeFromSuperview()
                    }
                }
            }
        }
    }
}
