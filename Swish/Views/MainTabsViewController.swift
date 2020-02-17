import UIKit

class MainTabsViewController: UITabBarController {

    let games = MainNavigationController(rootViewController: GamesViewController())
    let games1 = MainNavigationController(rootViewController: StandingsViewController())
    let games2 = MainNavigationController(rootViewController: StandingsViewController())
    let standings = MainNavigationController(rootViewController: StandingsViewController())
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [games, games1, games2, standings]
        tabBar.barTintColor = .red
        tabBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
