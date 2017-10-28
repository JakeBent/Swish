import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .red
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }   
}
