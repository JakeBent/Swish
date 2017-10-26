import UIKit

class GameDetailViewController: UIViewController {

    let boxScore = BoxScoreView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "ATL @ ATL"
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        boxScore.setup()
        view.addSubview(boxScore)
        boxScore.pinToEdges(of: view)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
