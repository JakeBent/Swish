import UIKit

class GameDetailViewController: UIViewController {

    let segmentedControl = SegmentedControl(titles: ["Live", "Game Details", "Box Score", "Post"])
    let boxScore = BoxScoreView()
    let liveRedditView = RedditCommentsView()
    var views: [UIView] {
        return [segmentedControl, boxScore, liveRedditView]
    }
    
    let game: Game
    var dataSource: GameDetailDataSource?
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
        
        title = "\(game.awayTeam.abbreviation) @ \(game.homeTeam.abbreviation)"
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        views.forEach { view.addSubview($0) }
        
        segmentedControl.pinTop(to: view.topAnchor, constant: 8)
        segmentedControl.pinLeft(to: view.leftAnchor, constant: 8)
        segmentedControl.pinRight(to: view.rightAnchor, constant: -8)
        segmentedControl.pinHeight(toConstant: 24)
        
        boxScore.pinTop(to: segmentedControl.bottomAnchor, constant: 8)
        boxScore.pinLeft(to: view.leftAnchor)
        boxScore.pinRight(to: view.rightAnchor)
        boxScore.pinBottom(to: view.bottomAnchor)

        liveRedditView.pinTop(to: segmentedControl.bottomAnchor, constant: 8)
        liveRedditView.pinLeft(to: view.leftAnchor)
        liveRedditView.pinRight(to: view.rightAnchor)
        liveRedditView.pinBottom(to: view.bottomAnchor)
        
        boxScore.isHidden = false
        liveRedditView.isHidden = true
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        
        setLoading(true)
        
        dataSource = GameDetailDataSource(self, boxScoreView: boxScore, game: game) { [weak self] in
            self?.setLoading(false)
        }
        
        liveRedditView.refresh()
    }
    
    @objc func selectionChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            boxScore.isHidden = true
            liveRedditView.isHidden = false
        case 1:
            boxScore.isHidden = false
            liveRedditView.isHidden = true
        case 2:
            boxScore.isHidden = true
            liveRedditView.isHidden = true
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
