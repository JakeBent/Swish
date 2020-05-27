import UIKit

struct Layout {
    static var viewWidth: CGFloat { return UIScreen.main.bounds.width }
    static var viewHeight: CGFloat { return UIScreen.main.bounds.height }
    static let marginStandard: CGFloat = 16
    static let marginMedium: CGFloat = 8
    static let marginSmall: CGFloat = 4

    static var minTabWidth: CGFloat { return viewWidth / 4.5 }

    struct Schedule {
        static let cellHeight: CGFloat = 108
    }
    
    struct BoxScore {
        static let keyRowHeight: CGFloat = 24
        static let playerRowHeight: CGFloat = 30
        static let namesColumnWidth: CGFloat = 100
        static let numberColumnWidth: CGFloat = 34
    }
}
