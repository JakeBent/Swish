import UIKit

class StandingsViewController: UIViewController {

    let scrollView = Generators.makeScrollView(paging: true)
    let header = CutoutTabHeader(initialColor: .red)
    let conferenceStandings = StandingsView()
    let overallStandings = StandingsView()
    private var views: [UIView] {
        return [header, scrollView]
    }
    private var scrollViewViews: [UIView] {
        return [conferenceStandings, overallStandings]
    }
    
    var dataSource: StandingsDataSource?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        title = "Standings"
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        views.forEach { view.addSubview($0) }
        
        header.pinTop(to: view.topAnchor)
        header.pinLeft(to: view.leftAnchor)
        header.pinRight(to: view.rightAnchor)
        header.pinHeight(toConstant: 50)
        
        scrollView.pinTop(to: header.bottomAnchor)
        scrollView.pinLeft(to: view.leftAnchor)
        scrollView.pinRight(to: view.rightAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
        
        scrollViewViews.forEach {
            scrollView.addSubview($0)
            $0.pinTop(to: scrollView.topAnchor)
            $0.pinBottom(to: scrollView.bottomAnchor)
            $0.pinHeight(to: scrollView.heightAnchor)
            $0.pinWidth(toConstant: Layout.viewWidth)
        }
        
        conferenceStandings.pinLeft(to: scrollView.leftAnchor)
        overallStandings.pinLeft(to: conferenceStandings.rightAnchor)
        overallStandings.pinRight(to: scrollView.rightAnchor)
        
        view.setLoading(true)
        
        dataSource = StandingsDataSource(self) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.view.setLoading(false)
    
                let tapAction: (TeamStats) -> Void = { [weak self] teamStats in
                    self?.navigationController?.pushViewController(TeamsViewController(teamStats: teamStats), animated: true)
                }
    
                self?.dataSource?.overallSource?.tapAction = tapAction
                self?.dataSource?.conferenceSource?.tapAction = tapAction
            }
       }
               
       scrollView.delegate = dataSource
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StandingsDataSource: NSObject, UIScrollViewDelegate, CutoutTabHeaderDelegate {
    
    var teamStats: [TeamStats] = [] {
        didSet {
            parent?.header.tabDelegate = self
            
            let eastTeams = teamStats.filter({ $0.conference == .east }).sorted {
                $0.conferenceRank < $1.conferenceRank
            }
            let westTeams = teamStats.filter({ $0.conference == .west }).sorted {
                $0.conferenceRank < $1.conferenceRank
            }
            let overallTeams = teamStats.sorted { $0.overallRank < $1.overallRank }
            
            conferenceSource = StandingsViewDataSource(teams: [eastTeams, westTeams])
            overallSource = StandingsViewDataSource(teams: [overallTeams])
        }
    }
    var overallSource: StandingsViewDataSource? {
        didSet { parent?.overallStandings.source = overallSource }
    }
    var conferenceSource: StandingsViewDataSource? {
        didSet { parent?.conferenceStandings.source = conferenceSource }
    }
    
    weak var parent: StandingsViewController?
    var didFinishLoading: (() -> Void)?
    var fullPageScrollView: UIScrollView? { return parent?.scrollView }
    
    init(_ parent: StandingsViewController, didFinishLoading: (() -> Void)? = nil) {
        super.init()
        
        self.parent = parent
        self.didFinishLoading = didFinishLoading
        
        refresh()
    }
    
    func refresh() {
        NBAService.shared.getStandings(progress: { [weak self] progress in
            DispatchQueue.main.async { [weak self] in
                self?.parent?.view.setProgress(progress)
            }
        }) { [weak self] err, teamStats in
            self?.teamStats = teamStats
            
            self?.didFinishLoading?()
        }
    }
    
    func numberOfTabs() -> Int {
        return 2
    }
    
    func titleForTab(index: Int) -> String {
        return index == 0 ? "Conference" : "Overall"
    }
    
    func colorForTab(index: Int) -> UIColor {
        return .main
    }
    
    func didTapTab(index: Int, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.parent?.scrollView.contentOffset = CGPoint(x: CGFloat(index) * Layout.viewWidth, y: 0)
        }, completion: completion)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _ = parent?.header.fullPageViewDidScroll(scrollView)
    }
}

class StandingsView: UITableView {
    
    var source: StandingsViewDataSource! {
        didSet {
            dataSource = source
            delegate = source
        }
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        register(cellClass: StandingsCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StandingsViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let teams: [[TeamStats]]
    var tapAction: ((TeamStats) -> Void)?
    
    init(teams: [[TeamStats]]) {
        self.teams = teams
        super.init()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if teams.count > 1 {
            return section == 0 ? " Eastern Conference" : " Western Conference"
        }

        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StandingsCell = tableView.dequeue()
        cell.setup(
            team: teams[indexPath.section][indexPath.row],
            rank: indexPath.row,
            isOverall: teams.count == 1
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ay")
        tapAction?(teams[indexPath.section][indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class StandingsCell: UITableViewCell {
    
    let rankLabel = Generators.makeLabel(fontSize: 20)
    let icon = Generators.makeImageView()
    let nameLabel = Generators.makeLabel(fontSize: 16)
    let recordLabel = Generators.makeLabel(fontSize: 16, align: .right)
    let moreInfoIcon = Generators.makeImageView(image: #imageLiteral(resourceName: "carat"), renderingMode: .alwaysTemplate, tintColor: .main)
    let infoLabel = Generators.makeLabel(shrinkFont: true)
    
    var views: [UIView] {
        return [rankLabel, icon, nameLabel, recordLabel, moreInfoIcon, infoLabel]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        views.forEach { contentView.addSubview($0) }
        
        rankLabel.pinLeft(to: contentView.leftAnchor, constant: 16)
        rankLabel.pinCenterY(to: contentView.centerYAnchor)
        rankLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        icon.pinLeft(to: rankLabel.rightAnchor, constant: 8)
        icon.pinCenterY(to: contentView.centerYAnchor)
        icon.pinHeight(toConstant: 50)
        icon.pinWidth(to: icon.heightAnchor)
        
        nameLabel.pinLeft(to: icon.rightAnchor, constant: 8)
        nameLabel.pinRight(to: recordLabel.leftAnchor, constant: -8)
        nameLabel.pinTop(to: contentView.topAnchor, constant: 8)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        recordLabel.pinWidth(toConstant: 70)
        recordLabel.pinCenterY(to: contentView.centerYAnchor)
        
        moreInfoIcon.pinRight(to: contentView.rightAnchor, constant: -16)
        moreInfoIcon.pinCenterY(to: contentView.centerYAnchor)
        moreInfoIcon.pinLeft(to: recordLabel.rightAnchor, constant: 8)
        moreInfoIcon.pinHeight(to: icon.heightAnchor, multiplier: 0.5)
        moreInfoIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        infoLabel.pinTop(to: nameLabel.bottomAnchor, constant: 8)
        infoLabel.pinBottom(to: contentView.bottomAnchor, constant: -8)
        infoLabel.pinLeft(to: nameLabel.leftAnchor)
        infoLabel.pinRight(to: recordLabel.leftAnchor, constant: -8)
        infoLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func setup(team: TeamStats, rank: Int, isOverall: Bool) {
        clear()

        rankLabel.text = "\(rank + 1)"
        icon.image = team.team.logo
        nameLabel.text = "\(team.team.city) \(team.team.name)"
        recordLabel.text = "\(team.wins) - \(team.losses)"
        
        if team.inPlayoffs {
            nameLabel.font = .mainBold(fontSize: nameLabel.font.pointSize)
        } else {
            nameLabel.font = .main(fontSize: nameLabel.font.pointSize)
        }
        
        let gamesBack = isOverall ? team.overallGamesBack : team.conferenceGamesBack
        
        infoLabel.text = "Win %: \(team.winPct) • Games Back: \(gamesBack)"
    }
    
    func clear() {
        infoLabel.text = nil
        rankLabel.text = nil
        icon.image = nil
        nameLabel.text = nil
        recordLabel.text = nil
        nameLabel.font = .main(fontSize: nameLabel.font.pointSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
