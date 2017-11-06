import UIKit

class StandingsViewController: UIViewController {

    let westStandings = StandingsView()
    let eastStandings = StandingsView()
    let segmentedControl = SegmentedControl(titles: ["West", "East"])
    
    var views: [UIView] {
        return [westStandings, eastStandings, segmentedControl]
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        title = "Standings"
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.forEach { view.addSubview($0) }
        
        segmentedControl.pinTop(to: view.topAnchor, constant: 8)
        segmentedControl.pinLeft(to: view.leftAnchor, constant: 8)
        segmentedControl.pinRight(to: view.rightAnchor, constant: -8)
        segmentedControl.pinHeight(toConstant: 24)

        westStandings.pinTop(to: segmentedControl.bottomAnchor, constant: 8)
        westStandings.pinLeft(to: view.leftAnchor)
        westStandings.pinRight(to: view.rightAnchor)
        westStandings.pinBottom(to: view.bottomAnchor)

        eastStandings.pinTop(to: segmentedControl.bottomAnchor, constant: 8)
        eastStandings.pinLeft(to: view.leftAnchor)
        eastStandings.pinRight(to: view.rightAnchor)
        eastStandings.pinBottom(to: view.bottomAnchor)

        eastStandings.isHidden = true
        segmentedControl.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        
        westStandings.source = StandingsDataSource(conference: .west)
        eastStandings.source = StandingsDataSource(conference: .east)
    }
    
    @objc func selectionChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            westStandings.isHidden = false
            eastStandings.isHidden = true
        case 1:
            westStandings.isHidden = true
            eastStandings.isHidden = false
        default: break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StandingsView: UITableView {
    
    var source: StandingsDataSource! {
        didSet {
            dataSource = source
            delegate = source
        }
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        translatesAutoresizingMaskIntoConstraints = false
        separatorInset = .zero
        allowsSelection = false
        register(cellClass: StandingsCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Conference {
    case west, east
}

class StandingsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let conference: Conference
    
    init(conference: Conference) {
        self.conference = conference
        super.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StandingsCell = tableView.dequeue()
        cell.setup(position: indexPath.row, conference: conference)
        return cell
    }
}

class StandingsCell: UITableViewCell {
    
    let icon = Generators.makeImageView()
    let nameLabel = Generators.makeLabel(fontSize: 20)
    let recordLabel = Generators.makeLabel(fontSize: 20, align: .right)
    
    var views: [UIView] {
        return [icon, nameLabel, recordLabel]
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        views.forEach { contentView.addSubview($0) }
        
        icon.pinLeft(to: contentView.leftAnchor, constant: 8)
        icon.pinCenterY(to: contentView.centerYAnchor)
        icon.pinHeight(to: contentView.heightAnchor, multiplier: 0.8)
        icon.pinWidth(to: icon.heightAnchor)
        
        nameLabel.pinLeft(to: icon.rightAnchor, constant: 8)
        nameLabel.pinRight(to: recordLabel.leftAnchor, constant: -8)
        nameLabel.pinCenterY(to: contentView.centerYAnchor)
        
        recordLabel.pinRight(to: contentView.rightAnchor, constant: -8)
        recordLabel.pinWidth(toConstant: 70)
        recordLabel.pinCenterY(to: contentView.centerYAnchor)
    }
    
    func setup(position: Int, conference: Conference) {
        icon.image = nil
        nameLabel.text = nil
        recordLabel.text = nil
        
        icon.image = #imageLiteral(resourceName: "hawks_logo")
        nameLabel.text = conference == .east ? "Atlanta Hawks" : "Denver Nuggets"
        recordLabel.text = "41-41"
        
        if position < 8 {
            nameLabel.font = .mainBold(fontSize: nameLabel.font.pointSize)
        } else {
            nameLabel.font = .main(fontSize: nameLabel.font.pointSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
