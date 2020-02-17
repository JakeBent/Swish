import UIKit

extension CGFloat {
    func keepBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        var result = self
        result = result > max ? max : result
        result = result < min ? min : result
        return result
    }
}

extension Int {
    func keepBetween(min: Int, max: Int) -> Int {
        var result = self
        result = result > max ? max : result
        result = result < min ? min : result
        return result
    }
}
