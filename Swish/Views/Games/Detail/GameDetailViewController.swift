import UIKit

class GameDetailViewController: UIViewController {
    let gameCell = GameCellView()
    let teamComparison: GameDetailTeamComparisonView!
    let boxScore = BoxScoreView()
    let scoringOverview = GameDetailScoringOverview()
    let liveRedditView = RedditCommentsView()
    let playByPlay = PlayByPlayView()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    var spacer: UIView {
        let view = Generators.makeView()
        let bar = Generators.makeView(bgColor: .altBg)
        view.addSubview(bar)
        bar.pinHeight(toConstant: 2)
        bar.pinToEdges(
            of: view,
            topOffset: 8,
            leftOffset: 48,
            bottomOffset: -8,
            rightOffset: -48
        )
        return view
    }
    var views: [UIView] {
        return [gameCell, spacer, teamComparison, spacer, boxScore, spacer, scoringOverview, spacer, playByPlay]
    }
    
    var expandedContentOffset: CGPoint?
    
    let game: Game
    var dataSource: GameDetailDataSource?
    
    init(game: Game) {
        self.game = game
        self.teamComparison = GameDetailTeamComparisonView(game: game)
        super.init(nibName: nil, bundle: nil)
        
        title = "\(game.awayTeam.abbreviation) @ \(game.homeTeam.abbreviation)"
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setLoading(true)

        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)

        var previousAnchor = scrollView.topAnchor
        views.forEach { view in
            scrollView.addSubview(view)
            view.pinLeft(to: scrollView.leftAnchor)
            view.pinRight(to: scrollView.rightAnchor)
            view.pinWidth(to: scrollView.widthAnchor)
            view.pinTop(to: previousAnchor)
            previousAnchor = view.bottomAnchor
        }
        views.last?.pinBottom(to: scrollView.bottomAnchor)
        
        gameCell.pinHeight(toConstant: Layout.Schedule.cellHeight)

        playByPlay.parentScrollView = scrollView
        boxScore.parentScrollView = scrollView

        liveRedditView.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dataSource = GameDetailDataSource(
            self,
            game: game
        ) { [weak self] in
            self?.view.setLoading(false)
        }
    }
    
    @objc func boxscoreExpandTapped() {
        if !boxScore.isExpanded {
            expandedContentOffset = scrollView.contentOffset
        }
        boxScore.isExpanded = !boxScore.isExpanded
        boxScore.expandButton.isEnabled = !boxScore.isExpanded
        boxScore.shrinkButton.isEnabled = boxScore.isExpanded

        if boxScore.isExpanded {
            scrollView.isScrollEnabled = false
            boxScore.containerHeightConstraint.constant = view.frame.height - 56
            UIView.animate(withDuration: 0.35) { [weak self] in
                self?.boxScore.expandButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.boxScore.shrinkButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.scrollView.contentOffset = CGPoint(
                    x: 0,
                    y: self?.boxScore.frame.origin.y ?? 0
                )
                self?.view.layoutIfNeeded()
            }
        } else {
            boxScore.containerHeightConstraint.constant = Layout.viewHeight / 4
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                self?.boxScore.shrinkButton.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.boxScore.expandButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.scrollView.contentOffset = self?.expandedContentOffset ?? .zero
                self?.view.layoutIfNeeded()
            }) { [weak self] _ in
                self?.scrollView.isScrollEnabled = true
            }
        }
    }

    func exec(animations: [() -> TeamGameStatsComparisonRow?]) {
        animations.enumerated().forEach { index, animation in
            let dIndex = Double(index)
            UIView.animate(withDuration: 0.2, delay: 0.05 * dIndex, options: [], animations: {
                let row = animation()
                row?.layoutIfNeeded()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayByPlayView: ExpandingScrollCell, UITableViewDataSource {
    var boxscore: Boxscore?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .zero
        tableView.register(cellClass: PlayView.self)
        return tableView
    }()
    
    var views: [UIView] {
        return [tableView]
    }

    override init() {
        super.init()
        
        titleLabel.text = "Play By Play"
        
        views.forEach { view in
            container.addSubview(view)
        }
        
        tableView.pinToEdges(of: container)
        
        tableView.dataSource = self
    }
    
    func setup(with boxscore: Boxscore?) {
        self.boxscore = boxscore
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return boxscore?.quarters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxscore?.quarters[section].plays.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0...3: return "  \(section + 1)Q"
        case 4: return boxscore?.quarters.count == 5 ? "  OT" : "  1OT"
        default: return "  \(section - 3)OT"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayView = tableView.dequeue()
        
        if let boxscore = boxscore {
            let homeScore = indexPath.section == 0 ? 0 : boxscore.quarters.reduce(into: 0) { result, quarter in
                if indexPath.section >= quarter.quarterNumber {
                    result += quarter.homeScore
                }
            }
            
            let awayScore = indexPath.section == 0 ? 0 : boxscore.quarters.reduce(into: 0) { result, quarter in
                if indexPath.section >= quarter.quarterNumber {
                    result += quarter.awayScore
                }
            }

            cell.setup(
                with: boxscore.quarters[indexPath.section].plays[indexPath.row],
                initialAwayScore: awayScore,
                initialHomeScore: homeScore,
                isOT: indexPath.section > 3
            )
        }
        
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayView: UITableViewCell {
    let secondsElapsedLabel = Generators.makeLabel(weight: .bold)
    let infoLabel = Generators.makeLabel()
    let teamIcon = Generators.makeImageView()
    let descriptionLabel = Generators.makeLabel(numberOfLines: 0)
    var views: [UIView] {
        [secondsElapsedLabel, teamIcon, infoLabel, descriptionLabel]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .none
        
        views.forEach { contentView.addSubview($0) }
        
        secondsElapsedLabel.pinTop(to: contentView.topAnchor, constant: 8)
        secondsElapsedLabel.pinLeft(to: contentView.leftAnchor, constant: 8)
        
        infoLabel.pinTop(to: contentView.topAnchor, constant: 8)
        infoLabel.pinRight(to: contentView.rightAnchor, constant: -8)
        
        teamIcon.pinLeft(to: secondsElapsedLabel.rightAnchor, constant: 8)
        teamIcon.pinTop(to: contentView.topAnchor, constant: 8)
        teamIcon.pinHeight(toConstant: 16)
        teamIcon.pinWidth(to: teamIcon.heightAnchor)
        
        descriptionLabel.pinTop(to: infoLabel.bottomAnchor, constant: 8)
        descriptionLabel.pinLeft(to: secondsElapsedLabel.leftAnchor)
        descriptionLabel.pinRight(to: infoLabel.rightAnchor)
        descriptionLabel.pinBottom(to: contentView.bottomAnchor, constant: -8)
    }
    
    func setup(with play: Play, initialAwayScore: Int, initialHomeScore: Int, isOT: Bool) {
        clear()
        
        let secondsElapsed = isOT ? 300 - play.secondsElapsed : 720 - play.secondsElapsed
        let seconds = secondsElapsed % 60
        
        secondsElapsedLabel.text = "\(secondsElapsed / 60):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        teamIcon.image = play.team.logo
        infoLabel.text = "\(play.team.abbreviation) +\(play.scoreChange)  •  \(initialAwayScore + play.awayScore)-\(initialHomeScore + play.homeScore)"
        descriptionLabel.text = play.playDescription
    }
    
    func clear() {
        secondsElapsedLabel.text = nil
        infoLabel.text = nil
        teamIcon.image = nil
        descriptionLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
