//
//  GameDetailTeamComparisonView.swift
//  Swish
//
//  Created by Jacob Benton on 2/17/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

//class GameDetailCollapsingCell: UIView {
//
//    let titleLabel = Generators.makeLabel(fontSize: 18, weight: .bold, text: "Team Stats")
//    let contentView = Generators.makeView()
//    let expandButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "expand"), color: .black)
//    let shrinkButton = Generators.makeIconButton(image: #imageLiteral(resourceName: "shrink"), color: .black)
//    let contentViewHeightConstraint: NSLayoutConstraint!
//    var views: [UIView] {
//        [titleLabel, contentView, shrinkButton, expandButton]
//    }
//
//    init() {
//        super.init(frame: .zero)
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        views.forEach { addSubview($0) }
//
//        titleLabel.pinLeft(to: leftAnchor, constant: 16)
//        titleLabel.pinTop(to: topAnchor, constant: 8)
//        titleLabel.pinBottom(to: bottomAnchor, constant: -8)
//
//        expandButton.pinRight(to: rightAnchor, constant: -16)
//        expandButton.pinHeight(to: titleLabel.heightAnchor)
//        expandButton.pinWidth(to: expandButton.heightAnchor)
//        expandButton.pinCenterY(to: titleLabel.centerYAnchor)
//
//        shrinkButton.pinRight(to: expandButton.rightAnchor)
//        shrinkButton.pinLeft(to: expandButton.leftAnchor)
//        shrinkButton.pinBottom(to: expandButton.bottomAnchor)
//        shrinkButton.pinTop(to: expandButton.topAnchor)
//        shrinkButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//
//        contentView.pinTop(to: titleLabel.bottomAnchor, constant: 8)
//        contentView.pinLeft(to: leftAnchor, constant: 16)
//        contentView.pinRight(to: rightAnchor, constant: -16)
//        contentView.pinBottom(to: bottomAnchor, constant: -16)
//
//        contentViewHeightConstraint = container.heightAnchor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class GameDetailTeamComparisonView: UIView {
    
    let titleLabel = Generators.makeLabel(fontSize: 18, weight: .bold, text: "Team Stats")
    let ptsRow = TeamGameStatsComparisonRow()
    let fgPctRow = TeamGameStatsComparisonRow()
    let fg3ptsMadeRow = TeamGameStatsComparisonRow()
    let fg3ptPctRow = TeamGameStatsComparisonRow()
    let ftAttRow = TeamGameStatsComparisonRow()
    let ftPctRow = TeamGameStatsComparisonRow()
    let rebRow = TeamGameStatsComparisonRow()
    let astRow = TeamGameStatsComparisonRow()
    let stlRow = TeamGameStatsComparisonRow()
    let blkRow = TeamGameStatsComparisonRow()
    let tovRow = TeamGameStatsComparisonRow()
    let foulsRow = TeamGameStatsComparisonRow()
    
    var comparisonRows: [TeamGameStatsComparisonRow] {
        [ptsRow, fgPctRow, fg3ptsMadeRow, fg3ptPctRow, ftAttRow, ftPctRow, rebRow, astRow, stlRow, blkRow, tovRow, foulsRow]
    }
    
    init(game: Game) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.pinLeft(to: leftAnchor, constant: 16)
        titleLabel.pinTop(to: topAnchor, constant: 8)
        
        var previousAnchor = titleLabel.bottomAnchor
        comparisonRows.enumerated().forEach { index, row in
            addSubview(row)
            row.pinLeft(to: leftAnchor, constant: 8)
            row.pinRight(to: rightAnchor, constant: -8)
            row.pinTop(to: previousAnchor, constant: index == 0 ? 16 : 8)
            previousAnchor = row.bottomAnchor
            
            row.homeBar.backgroundColor = game.homeTeam.teamColors.first ?? .main
            row.awayBar.backgroundColor = game.awayTeam.teamColors.first ?? .main
        }
        comparisonRows.last?.pinBottom(to: bottomAnchor, constant: -16)
    }
    
    func setup(with boxscore: Boxscore?) -> [() -> TeamGameStatsComparisonRow?] {
        var animations: [() -> TeamGameStatsComparisonRow?] = []
        
        animations.append(ptsRow.setup(stat: "PTS", awayAmount: boxscore?.awayTeamStats?.pts, homeAmount: boxscore?.homeTeamStats?.pts))
        animations.append(fgPctRow.setup(stat: "FG%", awayAmount: boxscore?.awayTeamStats?.fgPct, homeAmount: boxscore?.homeTeamStats?.fgPct))
        animations.append(fg3ptsMadeRow.setup(stat: "3PTM", awayAmount: boxscore?.awayTeamStats?.fg3PtMade, homeAmount: boxscore?.homeTeamStats?.fg3PtMade))
        animations.append(fg3ptPctRow.setup(stat: "3PT%", awayAmount: boxscore?.awayTeamStats?.fg3PtPct, homeAmount: boxscore?.homeTeamStats?.fg3PtPct))
        animations.append(ftAttRow.setup(stat: "FTA", awayAmount: boxscore?.awayTeamStats?.ftAtt, homeAmount: boxscore?.homeTeamStats?.ftAtt))
        animations.append(ftPctRow.setup(stat: "FT%", awayAmount: boxscore?.awayTeamStats?.ftPct, homeAmount: boxscore?.homeTeamStats?.ftPct))
        animations.append(rebRow.setup(stat: "REB", awayAmount: boxscore?.awayTeamStats?.reb, homeAmount: boxscore?.homeTeamStats?.reb))
        animations.append(astRow.setup(stat: "AST", awayAmount: boxscore?.awayTeamStats?.ast, homeAmount: boxscore?.homeTeamStats?.ast))
        animations.append(stlRow.setup(stat: "STL", awayAmount: boxscore?.awayTeamStats?.stl, homeAmount: boxscore?.homeTeamStats?.stl))
        animations.append(blkRow.setup(stat: "BLK", awayAmount: boxscore?.awayTeamStats?.blk, homeAmount: boxscore?.homeTeamStats?.blk))
        animations.append(tovRow.setup(stat: "TOV", awayAmount: boxscore?.awayTeamStats?.tov, homeAmount: boxscore?.homeTeamStats?.tov))
        animations.append(foulsRow.setup(stat: "FLS", awayAmount: boxscore?.awayTeamStats?.fouls, homeAmount: boxscore?.homeTeamStats?.fouls))
        
        return animations
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamGameStatsComparisonRow: UIView {
    
    let statLabel = Generators.makeLabel(fontSize: 14, align: .center, weight: .bold)
    let awayBar = Generators.makeView(bgColor: .main)
    let homeBar = Generators.makeView(bgColor: .goodHighlight)
    let awayCounterLabel = Generators.makeLabel(fontSize: 14)
    let homeCounterLabel = Generators.makeLabel(fontSize: 14)
    
    var awayBarWidthConstraint: NSLayoutConstraint!
    var homeBarWidthConstraint: NSLayoutConstraint!

    var views: [UIView] {
        return [awayCounterLabel, awayBar, statLabel, homeBar, homeCounterLabel]
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { view in
            addSubview(view)
        }
        
        statLabel.pinCenterY(to: centerYAnchor)
        statLabel.pinCenterX(to: centerXAnchor)
        statLabel.pinTop(to: topAnchor)
        statLabel.pinBottom(to: bottomAnchor)
        statLabel.pinWidth(toConstant: 42)
        
        homeBar.pinLeft(to: statLabel.rightAnchor, constant: 8)
        homeBarWidthConstraint = homeBar.widthAnchor.constraint(equalToConstant: 0)
        homeBarWidthConstraint.isActive = true
        homeBar.pinHeight(toConstant: 24)
        homeBar.pinCenterY(to: statLabel.centerYAnchor)
        
        awayBar.pinRight(to: statLabel.leftAnchor, constant: -8)
        awayBarWidthConstraint = awayBar.widthAnchor.constraint(equalToConstant: 0)
        awayBarWidthConstraint.isActive = true
        awayBar.pinHeight(toConstant: 24)
        awayBar.pinCenterY(to: statLabel.centerYAnchor)
    
        homeCounterLabel.pinLeft(to: homeBar.rightAnchor, constant: 8)
        homeCounterLabel.pinCenterY(to: statLabel.centerYAnchor)
        homeCounterLabel.alpha = 0
        
        awayCounterLabel.pinRight(to: awayBar.leftAnchor, constant: -8)
        awayCounterLabel.pinCenterY(to: statLabel.centerYAnchor)
        awayCounterLabel.alpha = 0
    }
    
    func setup(stat: String, awayAmount: Double?, homeAmount: Double?) -> () -> TeamGameStatsComparisonRow? {
        guard let homeAmount = homeAmount, let awayAmount = awayAmount else { return { self } }
        
        statLabel.text = stat
        awayCounterLabel.text = "\(awayAmount)"
        homeCounterLabel.text = "\(homeAmount)"
        
        return makeAnimations(homeAmount: CGFloat(homeAmount), awayAmount: CGFloat(awayAmount))
    }
    
    func setup(stat: String, awayAmount: Int?, homeAmount: Int?) -> () -> TeamGameStatsComparisonRow? {
        guard let homeAmount = homeAmount, let awayAmount = awayAmount else { return { self } }

        statLabel.text = stat
        awayCounterLabel.text = "\(awayAmount)"
        homeCounterLabel.text = "\(homeAmount)"
        
        return makeAnimations(homeAmount: CGFloat(homeAmount), awayAmount: CGFloat(awayAmount))
    }
    
    private func makeAnimations(homeAmount: CGFloat?, awayAmount: CGFloat?) -> () -> TeamGameStatsComparisonRow? {
        guard let homeAmount = homeAmount,
            let awayAmount = awayAmount
            else { return { self } }

        let maxBarWidth = Layout.viewWidth / 4
        let homePct = (homeAmount / maxBarWidth).keepBetween(min: 0, max: 1.2)
        let awayPct = (awayAmount / maxBarWidth).keepBetween(min: 0, max: 1.2)

        return { [weak self] in
            self?.homeBarWidthConstraint.constant = homePct * maxBarWidth
            self?.awayBarWidthConstraint.constant = awayPct * maxBarWidth
            self?.awayCounterLabel.alpha = 1
            self?.homeCounterLabel.alpha = 1
            return self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
