import UIKit

extension UIFont {
    static func main(fontSize: CGFloat) -> UIFont {
        return .systemFont(ofSize: fontSize)
    }

    static func mainBold(fontSize: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: fontSize)
    }
    
    static func mainHeavy(fontSize: CGFloat) -> UIFont {
        return .systemFont(ofSize: fontSize, weight: .heavy)
    }
}
