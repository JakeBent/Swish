import UIKit

class BoxScoreView: ExpandingScrollCell, UIScrollViewDelegate {
    
    var boxscore: Boxscore?

    let numbersScrollView = Generators.makeScrollView(vBounce: true, hBounce: true)
    let namesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let key = BoxScoreRow.createKey()
    lazy var keyRow: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(key)
        key.pinToEdges(of: scrollView)
        key.pinHeight(to: scrollView.heightAnchor)
        return scrollView
    }()
    let toggle = BoxScoreToggle()

    var views: [UIView] {
        return [numbersScrollView, keyRow, toggle, namesScrollView]
    }
    
    var nameRows: [UIView] = []
    var numberRows: [BoxScoreRow] = []
    
    override init() {
        super.init()
        
        titleLabel.text = "Boxscore"
        
        views.forEach { view in
            container.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
                
        toggle.pinLeft(to: container.leftAnchor, constant: 8)
        toggle.pinTop(to: container.topAnchor)
        toggle.pinHeight(toConstant: Layout.BoxScore.keyRowHeight)
        toggle.pinWidth(toConstant: Layout.BoxScore.namesColumnWidth)
        
        keyRow.pinTop(to: container.topAnchor)
        keyRow.pinLeft(to: toggle.rightAnchor)
        keyRow.pinRight(to: container.rightAnchor)
        keyRow.pinHeight(toConstant: Layout.BoxScore.keyRowHeight)
        
        numbersScrollView.pinTop(to: keyRow.bottomAnchor)
        numbersScrollView.pinLeft(to: keyRow.leftAnchor)
        numbersScrollView.pinRight(to: container.rightAnchor)
        numbersScrollView.pinBottom(to: container.bottomAnchor)
        
        namesScrollView.pinTop(to: toggle.bottomAnchor)
        namesScrollView.pinLeft(to: container.leftAnchor)
        namesScrollView.pinRight(to: numbersScrollView.leftAnchor)
        namesScrollView.pinBottom(to: container.bottomAnchor)
        
        numbersScrollView.delegate = self
        namesScrollView.delegate = self
        
        toggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleAdvanced)))
    }
    
    @objc func toggleAdvanced() {
        toggle.change()
        key.setAdvanced(toggle.toggle.isOn)
        numberRows.forEach { $0.setAdvanced(toggle.toggle.isOn) }
    }
    
    func setup(with boxscore: Boxscore?) {
        self.boxscore = boxscore
        guard let boxscore = boxscore else { return }
        
        func addPlayerRows(players: [PlayerStats]) {
            players.sorted(by: {
                $0.gameStats?.minSeconds ?? 0 > $1.gameStats?.minSeconds ?? 0
            }).forEach { player in
                let weight: FontWeight = player.gameStats?.gamesStarted == 1 ? .bold : .normal
                self.nameRows.append(Generators.makeLabel(
                    fontSize: 12,
                    weight: weight,
                    text: "\(player.firstName.first ?? "A"). \(player.lastName)"
                ))
                
                let row = BoxScoreRow()
                row.setup(with: player)
                self.numberRows.append(row)
            }
        }
        
        func layOutRows(parent: UIView, rows: [UIView], leftPad: CGFloat, maxWidth: CGFloat? = nil) {
            var previousAnchor = parent.topAnchor
            rows.forEach { row in
                parent.addSubview(row)
                row.pinLeft(to: parent.leftAnchor, constant: leftPad)
                row.pinRight(to: parent.rightAnchor)
                row.pinTop(to: previousAnchor)
                row.pinHeight(toConstant: Layout.BoxScore.playerRowHeight)
                if let maxWidth = maxWidth {
                    row.pinWidth(toConstant: maxWidth)
                }
                previousAnchor = row.bottomAnchor
            }
            rows.last?.pinBottom(to: parent.bottomAnchor)
        }
        
        nameRows.append(BoxScoreTeamRow(team: boxscore.awayTeam))
        numberRows.append(BoxScoreRow())
        addPlayerRows(players: boxscore.awayPlayerStats)
        
        nameRows.append(BoxScoreTeamRow(team: boxscore.homeTeam))
        numberRows.append(BoxScoreRow.createKey())
        addPlayerRows(players: boxscore.homePlayerStats)

        layOutRows(
            parent: numbersScrollView,
            rows: numberRows,
            leftPad: 0
        )
        layOutRows(
            parent: namesScrollView,
            rows: nameRows,
            leftPad: 8,
            maxWidth: Layout.BoxScore.namesColumnWidth
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == numbersScrollView {
            keyRow.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
            namesScrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
        if scrollView == namesScrollView {
            numbersScrollView.contentOffset = CGPoint(
                x: numbersScrollView.contentOffset.x,
                y: scrollView.contentOffset.y
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BoxScoreToggle: UIView {
    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .main
        toggle.isOn = false
        toggle.isUserInteractionEnabled = false
        return toggle
    }()
    let label = Generators.makeLabel(fontSize: 12, text: "Basic")
    var views: [UIView] { return [toggle, label] }
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        label.adjustsFontSizeToFitWidth = true
        label.pinTop(to: topAnchor)
        label.pinBottom(to: bottomAnchor)
        label.pinLeft(to: leftAnchor)
    
        toggle.pinRight(to: rightAnchor)
        toggle.pinLeft(to: label.rightAnchor)
        toggle.pinCenterY(to: centerYAnchor)
        toggle.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
    
    func change() {
        toggle.setOn(!toggle.isOn, animated: true)
        label.text = toggle.isOn ? "Advanced" : "Basic"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BoxScoreTeamRow: UIView {
    let nameLabel = Generators.makeLabel(fontSize: 12, weight: .bold)
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var views: [UIView] { return [nameLabel, icon] }
    
    init(team: Team) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLabel.pinLeft(to: icon.rightAnchor, constant: 4)
        nameLabel.pinRight(to: rightAnchor)
        nameLabel.pinTop(to: topAnchor)
        nameLabel.pinBottom(to: bottomAnchor)
        
        icon.pinLeft(to: leftAnchor)
        icon.pinTop(to: topAnchor)
        icon.pinBottom(to: bottomAnchor)
        icon.pinWidth(to: icon.heightAnchor)
        
        nameLabel.text = team.name
        icon.image = team.logo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BoxScoreRow: UIView {
    
    var isKey = false
    var isSelected = false
    let jerseyNumLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let positionLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let minLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let ptsLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fgLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fgPctLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fg2Label = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fg2PctLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fg3Label = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let fg3PctLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let ftLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let ftPctLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let offrebLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let defrebLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let rebLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let astLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let stlLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let blkLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let blkAgainstLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let tovLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let astTovRatioLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let foulsLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let foulsDrawnLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    let plusMinusLabel = Generators.makeLabel(fontSize: 12, align: .center, shrinkFont: true)
    
    var advLabelWidthConstraints: [NSLayoutConstraint] = []
    
    var labels: [UILabel] {
        return [jerseyNumLabel, positionLabel, minLabel, ptsLabel, fgLabel, fgPctLabel, fg2Label, fg2PctLabel, fg3Label, fg3PctLabel, ftLabel, ftPctLabel, offrebLabel, defrebLabel, rebLabel, astLabel, stlLabel, blkLabel, blkAgainstLabel, tovLabel, astTovRatioLabel, foulsLabel, foulsDrawnLabel, plusMinusLabel]
    }
    var advLabels: [UILabel] {
        return [jerseyNumLabel, positionLabel, fgPctLabel, fg2Label, fg2PctLabel, fg3PctLabel, ftPctLabel, blkAgainstLabel, astTovRatioLabel, foulsDrawnLabel]
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        var previousAnchor = leftAnchor
        
        labels.forEach { label in
            addSubview(label)
            label.pinTop(to: topAnchor)
            label.pinBottom(to: bottomAnchor)
            label.pinLeft(to: previousAnchor)
            if advLabels.contains(label) {
                advLabelWidthConstraints.append(label.widthAnchor.constraint(equalToConstant: 0))
            } else {
                label.pinWidth(toConstant: Layout.BoxScore.numberColumnWidth)
            }
            previousAnchor = label.rightAnchor
        }
        labels.last?.pinRight(to: rightAnchor, constant: -8)
        
        NSLayoutConstraint.activate(advLabelWidthConstraints)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rowTapped)))
    }
    
    @objc func rowTapped() {
        isSelected = !isSelected
        redraw()
    }
    
    func redraw() {
        if !isKey {
            backgroundColor = isSelected ? .altBg : .bg
        }
    }
    
    func setAdvanced(_ isAdvanced: Bool) {
        advLabelWidthConstraints.forEach {
            $0.constant = isAdvanced ? Layout.BoxScore.numberColumnWidth : 0
        }
    }
    
    func setup(with player: PlayerStats?) {
        guard let player = player,
            let stats = player.gameStats
            else { return }
        
        let totalSeconds = stats.minSeconds ?? 0
        let minutes = totalSeconds / 60
        let leftoverSeconds = totalSeconds % 60
        let minutesPlayed = "\(minutes):\(leftoverSeconds > 9 ? "\(leftoverSeconds)" : "0\(leftoverSeconds)")"
        let astTovRatio = stats.tov == 0 ? -1 : Float(stats.ast) / Float(stats.tov)
        
        jerseyNumLabel.text = "\(player.jerseyNumber)"
        positionLabel.text = "\(player.position)"
        minLabel.text = minutesPlayed
        ptsLabel.text = "\(stats.pts)"
        fgLabel.text = "\(stats.fgMade)/\(stats.fgAtt)"
        fgPctLabel.text = "\(stats.fgPct)"
        fg2Label.text = "\(stats.fg2PtMade)/\(stats.fg2PtAtt)"
        fg2PctLabel.text = "\(stats.fg2PtPct)"
        fg3Label.text = "\(stats.fg3PtMade)/\(stats.fg3PtAtt)"
        fg3PctLabel.text = "\(stats.fg3PtPct)"
        ftLabel.text = "\(stats.ftMade)/\(stats.ftAtt)"
        ftPctLabel.text = "\(stats.ftPct)"
        offrebLabel.text = "\(stats.offReb)"
        defrebLabel.text = "\(stats.defReb)"
        rebLabel.text = "\(stats.reb)"
        astLabel.text = "\(stats.ast)"
        stlLabel.text = "\(stats.stl)"
        blkLabel.text = "\(stats.blk)"
        blkAgainstLabel.text = "\(stats.blkAgainst)"
        tovLabel.text = "\(stats.tov)"
        astTovRatioLabel.text = "\(astTovRatio == -1 ? "∞" : String(format: "%.1f", astTovRatio))"
        foulsLabel.text = "\(stats.fouls)"
        foulsDrawnLabel.text = "\(stats.foulsDrawn)"
        plusMinusLabel.text = "\(stats.plusMinus > 0 ? "+" : "")\(stats.plusMinus)"
        
        if minutes >= 40 { minLabel.backgroundColor = .badHighlight }
        if stats.pts >= 30 { ptsLabel.backgroundColor = .goodHighlight }
        if stats.fgMade >= 10 && stats.fgPct >= 40 { fgLabel.backgroundColor = .goodHighlight }
        if stats.fgPct <= 30 && stats.fgAtt >= 8 { fgPctLabel.backgroundColor = .badHighlight }
        if stats.fgPct >= 60 && stats.fgMade >= 5 { fgPctLabel.backgroundColor = .goodHighlight }
        if stats.fg3PtMade >= 5 && stats.fg3PtPct >= 38 { fg3Label.backgroundColor = .goodHighlight }
        if stats.ftMade >= 10 && stats.ftPct >= 60 { ftLabel.backgroundColor = .goodHighlight }
        if stats.reb >= 10 { rebLabel.backgroundColor = .goodHighlight }
        if stats.ast >= 10 { astLabel.backgroundColor = .goodHighlight }
        if stats.stl >= 3 { stlLabel.backgroundColor = .goodHighlight }
        if stats.blk >= 3 { blkLabel.backgroundColor = .goodHighlight }
        if stats.blkAgainst >= 3 { blkAgainstLabel.backgroundColor = .badHighlight }
        if stats.tov >= 5 { tovLabel.backgroundColor = .badHighlight }
        if astTovRatio >= 5 || (astTovRatio == -1 && stats.ast >= 5) { astTovRatioLabel.backgroundColor = .goodHighlight }
        if stats.fouls >= 6 { foulsLabel.backgroundColor = .badHighlight }
        if stats.plusMinus >= 10 { plusMinusLabel.backgroundColor = .goodHighlight }
        if stats.plusMinus <= -10 { plusMinusLabel.backgroundColor = .badHighlight }
    }
    
    static func createKey() -> BoxScoreRow {
        let row = BoxScoreRow()
        row.isKey = true
        
        row.jerseyNumLabel.text = "NUM"
        row.positionLabel.text = "POS"
        row.minLabel.text = "MIN"
        row.ptsLabel.text = "PTS"
        row.fgLabel.text = "FG"
        row.fgPctLabel.text = "FG%"
        row.fg2Label.text = "2FG"
        row.fg2PctLabel.text =  "2FG%"
        row.fg3Label.text = "3FG"
        row.fg3PctLabel.text = "3FG%"
        row.ftLabel.text = "FT"
        row.ftPctLabel.text = "FT%"
        row.offrebLabel.text = "OFF"
        row.defrebLabel.text = "DEF"
        row.rebLabel.text = "REB"
        row.astLabel.text = "AST"
        row.stlLabel.text = "STL"
        row.blkLabel.text = "BLK"
        row.blkAgainstLabel.text = "BA"
        row.tovLabel.text = "TOV"
        row.astTovRatioLabel.text = "A/T"
        row.foulsLabel.text = "FLS"
        row.foulsDrawnLabel.text = "FA"
        row.plusMinusLabel.text = "+/-"
        
        row.labels.forEach { label in
            label.font = .mainBold(fontSize: label.font.pointSize)
        }
        
        row.backgroundColor = .altBg
        
        return row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
