import UIKit

class GameDetailViewController: UIViewController {

    let segmentedControl = SegmentedControl(titles: ["Live", "Box Score", "Post"])
    let boxScore = BoxScoreView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "ATL @ ATL"
        view.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(segmentedControl)
        segmentedControl.pinTop(to: view.topAnchor, constant: 8)
        segmentedControl.pinLeft(to: view.leftAnchor, constant: 8)
        segmentedControl.pinRight(to: view.rightAnchor, constant: -8)
        segmentedControl.pinHeight(toConstant: 24)
        
        boxScore.setup()
        view.addSubview(boxScore)
        boxScore.pinTop(to: segmentedControl.bottomAnchor, constant: 8)
        boxScore.pinLeft(to: view.leftAnchor)
        boxScore.pinRight(to: view.rightAnchor)
        boxScore.pinBottom(to: view.bottomAnchor)
        
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
    }
    
    @objc func selectionChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            boxScore.isHidden = true
        case 1:
            boxScore.isHidden = false
        case 2:
            boxScore.isHidden = true
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
