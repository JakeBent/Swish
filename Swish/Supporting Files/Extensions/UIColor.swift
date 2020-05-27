import UIKit

extension UIColor {
    static let main: UIColor = .red
    static let bg: UIColor = .white
    static let altBg = UIColor(white: 0.95, alpha: 1)
    static let goodHighlight = UIColor(rgb: 0xb6e6bd, alpha: 0.5)
    static let badHighlight = UIColor(rgb: 0xf0c9c9, alpha: 0.5)

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return (red, green, blue)
    }
    
    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: alpha
        )
    }
}
