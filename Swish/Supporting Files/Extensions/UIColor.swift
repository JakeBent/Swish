import UIKit

extension UIColor {
    static let main: UIColor = .red
    static let bg: UIColor = .white
    static let altBg: UIColor = UIColor(white: 0.95, alpha: 1)

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return (red, green, blue)
    }
}
