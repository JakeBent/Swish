//
//  TeamsViewController.swift
//  Swish
//
//  Created by Jacob Benton on 3/10/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {
    let teamStats: TeamStats
    
    let scrollView = Generators.makeScrollView(vBounce: true)
    lazy var teamOverview = TeamOverview(teamStats: teamStats)
    lazy var statsOverview: TeamStatsOverview = {
        let view = TeamStatsOverview(teamStats: teamStats)
        return view
    }()
    var spacer: UIView { Generators.makeSpacer() }
    var views: [UIView] {
        [teamOverview, spacer, statsOverview]
    }
    
    init(teamStats: TeamStats) {
        self.teamStats = teamStats
        super.init(nibName: nil, bundle: nil)
        
        title = "\(teamStats.team.name)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)
        
        var previousAnchor = scrollView.topAnchor
        views.forEach {
            scrollView.addSubview($0)
            $0.pinLeft(to: scrollView.leftAnchor)
            $0.pinRight(to: scrollView.rightAnchor)
            $0.pinWidth(to: scrollView.widthAnchor)
            $0.pinTop(to: previousAnchor)
            previousAnchor = $0.bottomAnchor
        }
        views.last?.pinBottom(to: scrollView.bottomAnchor)

        statsOverview.parentScrollView = scrollView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamOverview: ExpandingScrollCell {
    override var canExpand: Bool { false }
    let teamStats: TeamStats?
    
    var rows: [TeamStatsRow] = []
    
    init(teamStats: TeamStats?) {
        self.teamStats = teamStats
        super.init()
        
        titleLabel.text = "Team Overview"
        
        if let teamStats = teamStats {
            rows = [
                TeamStatsRow(name: "City", perGame: teamStats.team.city),
                TeamStatsRow(name: "Name", perGame: teamStats.team.name),
                TeamStatsRow(name: "Colors", colors: teamStats.team.teamColors),
                TeamStatsRow(name: "Home Venue", perGame: teamStats.team.homeVenueName),
                TeamStatsRow(name: "Twitter", perGame: "@\(teamStats.team.twitter)"),
                TeamStatsRow(name: "Games Played", perGame: "\(teamStats.gamesPlayed)"),
                TeamStatsRow(name: "Record", perGame: "\(teamStats.wins) - \(teamStats.losses)"),
                TeamStatsRow(name: "Conference", perGame: teamStats.conference.rawValue),
                TeamStatsRow(name: "Conference Rank", perGame: "\(teamStats.conferenceRank)"),
                TeamStatsRow(name: "Conference Games Back", perGame: "\(teamStats.conferenceGamesBack)"),
                TeamStatsRow(name: "Overall Rank", perGame: "\(teamStats.overallRank)"),
                TeamStatsRow(name: "Overall Games Back", perGame: "\(teamStats.overallGamesBack)"),
                
            ]
        }
        
        var previousAnchor = container.topAnchor
        rows.forEach { row in
            container.addSubview(row)
            row.pinLeft(to: container.leftAnchor, constant: 8)
            row.pinRight(to: container.rightAnchor, constant: -8)
            row.pinTop(to: previousAnchor)
            previousAnchor = row.bottomAnchor
        }
        rows.last?.pinBottom(to: container.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamStatsOverview: ExpandingScrollCell {
    let stats: GameStats?
    
    var rows: [TeamStatsRow] = []
    let scrollView = Generators.makeScrollView(vBounce: true)
    
    init(teamStats: TeamStats) {
        self.stats = teamStats.stats
        super.init()
        
        titleLabel.text = "Team Stats Overview"

        if let stats = self.stats {
            rows = [
                TeamStatsRow.makeStatsKey(),
                TeamStatsRow(name: "Points", total: stats.pts, perGame: stats.ptsPerGame),
                TeamStatsRow(name: "Field Goals Att", total: stats.fgAtt, perGame: stats.fgAttPerGame),
                TeamStatsRow(name: "Field Goals Made", total: stats.fgMade, perGame: stats.fgMadePerGame),
                TeamStatsRow(name: "Field Goal %", perGame: stats.fgPct),
                TeamStatsRow(name: "2PT Field Goals Att", total: stats.fg2PtAtt, perGame: stats.fg2PtAttPerGame),
                TeamStatsRow(name: "2PT Field Goals Made", total: stats.fg2PtMade, perGame: stats.fg2PtMadePerGame),
                TeamStatsRow(name: "2PT Field Goal %", perGame: stats.fg2PtPct),
                TeamStatsRow(name: "3PT Field Goals Att", total: stats.fg3PtAtt, perGame: stats.fg2PtAttPerGame),
                TeamStatsRow(name: "3PT Field Goals Made", total: stats.fg3PtMade, perGame: stats.fg3PtMadePerGame),
                TeamStatsRow(name: "3PT Field Goal %", perGame: stats.fg3PtPct),
                TeamStatsRow(name: "Free Throws Att", total: stats.ftAtt, perGame: stats.ftAttPerGame),
                TeamStatsRow(name: "Free Throws Made", total: stats.ftMade, perGame: stats.ftMadePerGame),
                TeamStatsRow(name: "Free Throw %", perGame: stats.ftPct),
                TeamStatsRow(name: "Offensive Rebounds", total: stats.offReb, perGame: stats.offRebPerGame),
                TeamStatsRow(name: "Defensive Rebounds", total: stats.defReb, perGame: stats.defRebPerGame),
                TeamStatsRow(name: "Rebounds", total: stats.reb, perGame: stats.rebPerGame),
                TeamStatsRow(name: "Assists", total: stats.ast, perGame: stats.astPerGame),
                TeamStatsRow(name: "Turnovers", total: stats.tov, perGame: stats.tovPerGame),
                TeamStatsRow(name: "Steals", total: stats.stl, perGame: stats.tovPerGame),
                TeamStatsRow(name: "Blocks", total: stats.blk, perGame: stats.blkPerGame),
                TeamStatsRow(name: "Blocks Against", total: stats.blkAgainst, perGame: stats.blkAgainstPerGame),
                TeamStatsRow(name: "Points Against", total: stats.ptsAgainst, perGame: stats.ptsAgainstPerGame),
                TeamStatsRow(name: "Fouls", total: stats.fouls, perGame: stats.foulsPerGame),
                TeamStatsRow(name: "Personal Fouls", total: stats.foulPers, perGame: stats.foulPersPerGame),
                TeamStatsRow(name: "Technical Fouls", total: stats.foulTech, perGame: stats.foulTechPerGame),
                TeamStatsRow(name: "Ejections", total: stats.ejections),
                TeamStatsRow(name: "Plus/Minus", total: stats.plusMinus, perGame: stats.plusMinusPerGame),
            ]
        }
        
        container.addSubview(scrollView)
        scrollView.pinToEdges(of: container)
        
        var previousAnchor = scrollView.topAnchor
        rows.forEach { row in
            scrollView.addSubview(row)
            row.pinLeft(to: scrollView.leftAnchor, constant: 8)
            row.pinRight(to: scrollView.rightAnchor, constant: -8)
            row.pinWidth(to: scrollView.widthAnchor, constant: -16)
            row.pinTop(to: previousAnchor)
            previousAnchor = row.bottomAnchor
        }
        rows.last?.pinBottom(to: scrollView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamStatsRow: UIView {
    let nameLabel = Generators.makeLabel(weight: .bold)
    let totalLabel = Generators.makeLabel(align: .right)
    let perGameLabel = Generators.makeLabel(align: .right)
    var views: [UILabel] {
        [nameLabel, totalLabel, perGameLabel]
    }
    
    init(name: String, total: Int? = nil, perGame: Double? = nil) {
        super.init(frame: .zero)
        setup(
            name: name,
            total: "\(total == nil ? "" : "\(total!)")",
            perGame: "\(perGame == nil ? "": "\(perGame!)")"
        )
    }
    
    init(name: String, total: String? = nil, perGame: String? = nil) {
        super.init(frame: .zero)
        
        setup(name: name, total: total, perGame: perGame)
    }
    
    init(name: String, colors: [UIColor]) {
        super.init(frame: .zero)
        
        setup(name: name)
        showColors(colors: colors)
    }
    
    func setup(name: String, total: String? = nil, perGame: String? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach {
            addSubview($0)
            $0.pinTop(to: topAnchor, constant: 4)
            $0.pinBottom(to: bottomAnchor, constant: -4)
            $0.pinHeight(toConstant: 20)
        }

        nameLabel.pinLeft(to: leftAnchor)
        nameLabel.pinRight(to: centerXAnchor, constant: -4)

        totalLabel.pinLeft(to: centerXAnchor, constant: 4)

        perGameLabel.pinLeft(to: totalLabel.rightAnchor, constant: 8)
        perGameLabel.pinRight(to: rightAnchor)
        
        if total != nil && perGame != nil {
            perGameLabel.pinWidth(to: totalLabel.widthAnchor)
        }
    
        nameLabel.text = name
        totalLabel.text = total
        perGameLabel.text = perGame
    }
    
    func showColors(colors: [UIColor]) {
        var previousAnchor = rightAnchor
        colors.reversed().forEach { color in
            let view: UIView = {
                let view = Generators.makeView(bgColor: color)
                view.layer.cornerRadius = 10
                return view
            }()
            let spacer = Generators.makeView()
            [view, spacer].forEach {
                addSubview($0)
                $0.pinHeight(to: 20)
                $0.pinWidth(to: $0.heightAnchor)
                $0.pinCenterY(to: centerYAnchor)
            }
            view.pinRight(to: previousAnchor)
            spacer.pinRight(to: view.leftAnchor)
            previousAnchor = spacer.leftAnchor
        }
    }
    
    static func makeStatsKey() -> TeamStatsRow {
        let row = TeamStatsRow(name: "Statistic", total: "Total", perGame: "Per Game")
        row.views.forEach { $0.font = .mainBold(fontSize: $0.font.pointSize) }
        return row
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
