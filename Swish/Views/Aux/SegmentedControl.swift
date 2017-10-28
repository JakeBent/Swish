import UIKit

class SegmentedControl: UISegmentedControl {

    init(titles: [String]) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        tintColor = .red
        
        var count = 0
        titles.forEach { title in
            insertSegment(withTitle: title, at: count, animated: false)
            count += 1
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
