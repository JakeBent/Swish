import UIKit

enum FontWeight {
    case normal, bold
}

struct Generators {
    
    static func makeLabel(fontSize: CGFloat = 14, align: NSTextAlignment = .left, weight: FontWeight = .normal, numberOfLines: Int = 1, color: UIColor = .black, text: String? = nil, bgColor: UIColor = .clear) -> UILabel {
        let label = UILabel()
        
        label.textAlignment = align
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byTruncatingTail
        label.textColor = color
        label.text = text
        label.backgroundColor = bgColor
        
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
        
        button.imageView?.contentMode = .scaleAspectFill
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
}
