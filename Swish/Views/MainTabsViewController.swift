import UIKit

class MainTabsViewController: UITabBarController {

    let games = MainNavgiationController(rootViewController: GamesViewController())
    let games1 = MainNavgiationController(rootViewController: GamesViewController())
    let games2 = MainNavgiationController(rootViewController: GamesViewController())

    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [games, games1, games2]
        tabBar.barTintColor = .red
        tabBar.tintColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
