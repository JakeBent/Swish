import UIKit

class MainTabsViewController: UITabBarController {

    let games = MainNavigationController(rootViewController: GamesViewController())
    let games1 = MainNavigationController(rootViewController: GamesViewController())
    let games2 = MainNavigationController(rootViewController: GamesViewController())
    let standings = MainNavigationController(rootViewController: StandingsViewController())
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [games, games1, games2, standings]
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
