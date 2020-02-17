import UIKit

class BoxScoreView: UIView, UIScrollViewDelegate {
    
    var boxscore: Boxscore?
    let numbersScrollView = UIScrollView()
    let namesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let keyRow: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        let key = BoxScoreRow.createKey()
        scrollView.addSubview(key)
        key.pinToEdges(of: scrollView)
        key.pinHeight(to: scrollView.heightAnchor)
        return scrollView
    }()
    let toggle = BoxScoreToggle()
    var views: [UIView] {
        return [numbersScrollView, keyRow, toggle, namesScrollView]
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
                
        toggle.pinLeft(to: leftAnchor, constant: 8)
        toggle.pinTop(to: topAnchor)
        toggle.pinHeight(toConstant: 24)
        toggle.pinWidth(toConstant: 100)
        
        keyRow.pinTop(to: topAnchor)
        keyRow.pinLeft(to: toggle.rightAnchor)
        keyRow.pinRight(to: rightAnchor)
        keyRow.pinHeight(toConstant: 24)
        
        numbersScrollView.pinTop(to: keyRow.bottomAnchor)
        numbersScrollView.pinLeft(to: keyRow.leftAnchor)
        numbersScrollView.pinRight(to: rightAnchor)
        numbersScrollView.pinBottom(to: bottomAnchor)
        
        namesScrollView.pinTop(to: toggle.bottomAnchor)
        namesScrollView.pinLeft(to: leftAnchor)
        namesScrollView.pinRight(to: numbersScrollView.leftAnchor)
        namesScrollView.pinBottom(to: bottomAnchor)
        
        numbersScrollView.delegate = self
        namesScrollView.delegate = self
        
        toggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleAdvanced)))
    }
    
    @objc func toggleAdvanced() {
        toggle.change()

        if toggle.toggle.isOn {
            print("yay")
        } else { print("Nay")}
    }
    
    func setup(with boxscore: Boxscore?, isAdvanced: Bool = false) {
        self.boxscore = boxscore
        guard let boxscore = boxscore else { return }
        
        var nameRows: [UIView] = []
        var numberRows: [UIView] = []
        
        let addPlayerRows: ([PlayerStats]) -> Void = { players in
            players.sorted(by: {
                $0.gameStats?.minSeconds ?? 0 > $1.gameStats?.minSeconds ?? 0
            }).forEach { player in
                let weight: FontWeight = player.gameStats?.gamesStarted == 1 ? .bold : .normal
                nameRows.append(Generators.makeLabel(
                    fontSize: 12,
                    weight: weight,
                    text:"\(player.firstName.first ?? "A"). \(player.lastName)"
                ))
                
                let row = BoxScoreRow()
                row.setup(with: player.gameStats)
                numberRows.append(row)
            }
        }
        
        let layOutRows: (UIView, [UIView], CGFloat) -> Void = { parent, views, leftPad in
            var previousAnchor = parent.topAnchor
            views.forEach { row in
                parent.addSubview(row)
                row.pinLeft(to: parent.leftAnchor, constant: leftPad)
                row.pinRight(to: parent.rightAnchor)
                row.pinTop(to: previousAnchor)
                row.pinHeight(toConstant: 30)
                previousAnchor = row.bottomAnchor
            }
            views.last?.pinBottom(to: parent.bottomAnchor)
        }
        
        nameRows.append(BoxScoreTeamRow(team: boxscore.awayTeam))
        numberRows.append(BoxScoreRow())
        addPlayerRows(boxscore.awayPlayerStats)
        
        nameRows.append(BoxScoreTeamRow(team: boxscore.homeTeam))
        numberRows.append(BoxScoreRow())
        addPlayerRows(boxscore.homePlayerStats)

        layOutRows(numbersScrollView, numberRows, 0)
        layOutRows(namesScrollView, nameRows, 8)
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
    let minLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let ptsLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let fgLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let fg3Label = Generators.makeLabel(fontSize: 12, align: .center)
    let ftLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let offrebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let defrebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let rebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let astLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let stlLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let blkLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let tovLabel = Generators.makeLabel(fontSize: 12, align: .center)
    
    var numberLabels: [UILabel] {
        return [minLabel, ptsLabel, fgLabel, fg3Label, ftLabel, offrebLabel,
            defrebLabel, rebLabel, astLabel, stlLabel, blkLabel, tovLabel]
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        var previousAnchor = leftAnchor
        
        numberLabels.forEach { label in
            addSubview(label)
            label.pinTop(to: topAnchor)
            label.pinBottom(to: bottomAnchor)
            label.pinLeft(to: previousAnchor)
            label.pinWidth(toConstant: Layout.BoxScore.numberColumnWidth)
            previousAnchor = label.rightAnchor
        }
        numberLabels.last?.pinRight(to: rightAnchor, constant: -8)
        
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
    
    func setup(with stats: GameStats?) {
        guard let stats = stats else { return }
        
        let totalSeconds = stats.minSeconds ?? 0
        let minutesPlayed = "\(totalSeconds / 60):\(totalSeconds % 60)"
        
        minLabel.text = minutesPlayed
        ptsLabel.text = "\(stats.pts)"
        fgLabel.text = "\(stats.fgMade)/\(stats.fgAtt)"
        fg3Label.text = "\(stats.fg3PtMade)/\(stats.fg3PtAtt)"
        ftLabel.text = "\(stats.ftMade)/\(stats.ftAtt)"
        offrebLabel.text = "\(stats.offReb)"
        defrebLabel.text = "\(stats.defReb)"
        rebLabel.text = "\(stats.reb)"
        astLabel.text = "\(stats.ast)"
        stlLabel.text = "\(stats.stl)"
        blkLabel.text = "\(stats.blk)"
        tovLabel.text = "\(stats.tov)"
    }
    
    static func createKey() -> BoxScoreRow {
        let row = BoxScoreRow()
        row.isKey = true
        row.minLabel.text = "MIN"
        row.ptsLabel.text = "PTS"
        row.fgLabel.text = "FG"
        row.fg3Label.text = "3FG"
        row.ftLabel.text = "FT"
        row.offrebLabel.text = "OFF"
        row.defrebLabel.text = "DEF"
        row.rebLabel.text = "REB"
        row.astLabel.text = "AST"
        row.stlLabel.text = "STL"
        row.blkLabel.text = "BLK"
        row.tovLabel.text = "TOV"
        
        row.numberLabels.forEach { label in
            label.font = .mainBold(fontSize: label.font.pointSize)
        }
        
        return row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
