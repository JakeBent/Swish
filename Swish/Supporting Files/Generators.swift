import UIKit

enum FontWeight {
    case normal, bold
}

struct Generators {
    
    static func makeLabel(fontSize: CGFloat = 14, align: NSTextAlignment = .left, weight: FontWeight = .normal) -> UILabel {
        let label = UILabel()
        label.textAlignment = align
        
        switch weight {
        case .normal:
            label.font = .main(fontSize: fontSize)
        case .bold:
            label.font = .mainBold(fontSize: fontSize)
        }

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    static func makeImageView(contentMode: UIViewContentMode = .scaleAspectFill) -> UIImageView {
        let imageView = UIImageView()
        
        imageView.contentMode = contentMode
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
}
