import UIKit

enum FontWeight {
    case normal, bold
}

struct Generators {
    
    static func makeLabel(
        fontSize: CGFloat = 14,
        align: NSTextAlignment = .left,
        weight: FontWeight = .normal,
        numberOfLines: Int = 1,
        color: UIColor = .black,
        text: String? = nil,
        bgColor: UIColor = .clear,
        shrinkFont: Bool = false
    ) -> UILabel {

        let label = UILabel()
        
        label.textAlignment = align
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byTruncatingTail
        label.textColor = color
        label.text = text
        label.backgroundColor = bgColor
        label.adjustsFontSizeToFitWidth = shrinkFont
        
        switch weight {
        case .normal:
            label.font = .main(fontSize: fontSize)
        case .bold:
            label.font = .mainBold(fontSize: fontSize)
        }

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    static func makeImageView(contentMode: UIView.ContentMode = .scaleAspectFill, image: UIImage? = nil, renderingMode: UIImage.RenderingMode = .alwaysOriginal, tintColor: UIColor = .red, rotation: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        
        imageView.contentMode = contentMode
        imageView.image = image?.withRenderingMode(renderingMode)
        imageView.tintColor = tintColor
        imageView.transform = CGAffineTransform(rotationAngle: rotation)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    static func makeIconButton(image: UIImage, color: UIColor = .black, rotation: CGFloat = 0) -> UIButton {
        let button = UIButton()
        
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = color
        button.transform = CGAffineTransform(rotationAngle: rotation)
     
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func makeStack(direction: NSLayoutConstraint.Axis = .vertical) -> UIStackView {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
    
    static func makeView(bgColor: UIColor = .bg) -> UIView {
        let view = UIView()
        
        view.backgroundColor = bgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
    
    static func makeScrollView(paging: Bool = false, vBounce: Bool = false, hBounce: Bool = false) -> UIScrollView {
        let scrollView = UIScrollView()
        
        scrollView.isPagingEnabled = paging
        scrollView.alwaysBounceVertical = vBounce
        scrollView.alwaysBounceHorizontal = hBounce
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }
    
    static func makeSpacer() -> UIView {
        let view = makeView()
        let bar = makeView(bgColor: .altBg)
        view.addSubview(bar)
        bar.pinHeight(toConstant: 2)
        bar.pinToEdges(
            of: view,
            topOffset: 8,
            leftOffset: 48,
            bottomOffset: -8,
            rightOffset: -48
        )
        return view
    }
}
