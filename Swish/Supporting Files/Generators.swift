import UIKit

enum FontWeight {
    case normal, bold
}

struct Generators {
    
    static func makeLabel(fontSize: CGFloat = 14, align: NSTextAlignment = .left, weight: FontWeight = .normal, numberOfLines: Int = 1, color: UIColor = .black) -> UILabel {
        let label = UILabel()
        
        label.textAlignment = align
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        label.textColor = color
        
        switch weight {
        case .normal:
            label.font = .main(fontSize: fontSize)
        case .bold:
            label.font = .mainBold(fontSize: fontSize)
        }

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    static func makeImageView(contentMode: UIViewContentMode = .scaleAspectFill, image: UIImage? = nil, renderingMode: UIImageRenderingMode = .alwaysOriginal, tintColor: UIColor = .red, rotation: CGFloat = 0) -> UIImageView {
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
    
}
