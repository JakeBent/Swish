//
//  GameDetailScoringOverview.swift
//  Swish
//
//  Created by Jacob Benton on 2/17/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

class GameDetailScoringOverview: UIView {
 
    let titleLabel = Generators.makeLabel(fontSize: 18, weight: .bold, text: "Scoring Overview")
    let quartersOverview = GameDetailQuartersOverview()
    var views: [UIView] {
        [titleLabel, quartersOverview]
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { view in
            addSubview(view)
        }

        titleLabel.pinLeft(to: leftAnchor, constant: 16)
        titleLabel.pinTop(to: topAnchor, constant: 8)

        quartersOverview.pinTop(to: titleLabel.bottomAnchor, constant: 8)
        quartersOverview.pinLeft(to: leftAnchor, constant: 16)
        quartersOverview.pinRight(to: rightAnchor, constant: -16)
        quartersOverview.pinBottom(to: bottomAnchor, constant: -16)

    }
    
    func setup(with boxscore: Boxscore?) {
        guard let boxscore = boxscore else { return }

        quartersOverview.setup(with: boxscore)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameDetailQuartersOverview: UIView {
    let homeNameLabel = Generators.makeLabel(fontSize: 10, align: .center)
    let awayNameLabel = Generators.makeLabel(fontSize: 10, align: .center)
    let homeScoreLabel = Generators.makeLabel(fontSize: 10, align: .center)
    let awayScoreLabel = Generators.makeLabel(fontSize: 10, align: .center)
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()
    var quarterViews: [QuarterInfo] = []
    var views: [UIView] {
        [homeNameLabel, awayNameLabel, homeScoreLabel, awayScoreLabel, scrollView]
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach { addSubview($0) }
        
        awayNameLabel.pinCenterY(to: centerYAnchor)
        awayNameLabel.pinHeight(to: heightAnchor, multiplier: 1/3)
        
        homeNameLabel.pinTop(to: awayNameLabel.bottomAnchor)
        homeNameLabel.pinLeft(to: awayNameLabel.leftAnchor)
        homeNameLabel.pinHeight(to: heightAnchor, multiplier: 1/3)
        homeNameLabel.pinBottom(to: bottomAnchor)
        
        awayScoreLabel.pinTop(to: awayNameLabel.topAnchor)
        awayScoreLabel.pinBottom(to: awayNameLabel.bottomAnchor)
        
        homeScoreLabel.pinTop(to: awayScoreLabel.bottomAnchor)
        homeScoreLabel.pinRight(to: awayScoreLabel.rightAnchor)
        homeScoreLabel.pinBottom(to: bottomAnchor)
        
        scrollView.pinTop(to: topAnchor)
        scrollView.pinBottom(to: bottomAnchor)
        scrollView.pinLeft(to: homeNameLabel.rightAnchor, constant: 16)
        scrollView.pinRight(to: homeScoreLabel.leftAnchor, constant: -16)
        scrollView.pinWidth(to: widthAnchor, multiplier: 0.7)
        scrollView.pinCenterX(to: centerXAnchor)
    }
    
    func setup(with boxscore: Boxscore) {

        homeNameLabel.text = boxscore.homeTeam.abbreviation
        awayNameLabel.text = boxscore.awayTeam.abbreviation

        if let homeScore = boxscore.homeScore, let awayScore = boxscore.awayScore {
            homeScoreLabel.text = "\(homeScore)"
            awayScoreLabel.text = "\(awayScore)"
            
            if boxscore.isComplete {
                let homeWin = homeScore > awayScore
                homeNameLabel.font = homeWin ? .mainHeavy(fontSize: 10) : .main(fontSize: 10)
                awayNameLabel.font = homeWin ? .main(fontSize: 10) : .mainHeavy(fontSize: 10)
                homeScoreLabel.font = homeWin ? .mainHeavy(fontSize: 10) : .main(fontSize: 10)
                awayScoreLabel.font = homeWin ? .main(fontSize: 10) : .mainHeavy(fontSize: 10)
            }
        }
        
        var previousAnchor = scrollView.leftAnchor
        boxscore.quarters.enumerated().forEach { index, quarter in
            let quarterInfo = QuarterInfo(quarter: quarter)
            quarterViews.append(quarterInfo)
            scrollView.addSubview(quarterInfo)
            quarterInfo.pinTop(to: scrollView.topAnchor)
            quarterInfo.pinBottom(to: scrollView.bottomAnchor)
            quarterInfo.pinHeight(to: scrollView.heightAnchor)
            quarterInfo.pinLeft(to: previousAnchor)
            previousAnchor = quarterInfo.rightAnchor
            
            if index == 0 {
                quarterInfo.pinRight(to: scrollView.rightAnchor)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuarterInfo: UIView {
    var hasDrawnBorders = false
    let quarterNameLabel = Generators.makeLabel(fontSize: 10, align: .center, weight: .bold)
    let homeScore = Generators.makeLabel(fontSize: 10, align: .center)
    let awayScore = Generators.makeLabel(fontSize: 10, align: .center)
    var views: [UIView] {
        [quarterNameLabel, homeScore, awayScore]
    }
    
    init(quarter: Quarter) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        var previousAnchor = topAnchor
        views.forEach { view in
            addSubview(view)
            view.pinTop(to: previousAnchor)
            view.pinLeft(to: leftAnchor)
            view.pinRight(to: rightAnchor)
            view.pinHeight(toConstant: 32)
            view.pinWidth(to: view.heightAnchor)
            previousAnchor = view.bottomAnchor
        }
        views.last?.pinBottom(to: bottomAnchor)
        
        let num = quarter.quarterNumber
        let quarterName = num > 4
            ? "\(num == 5 ? "OT" : "\(num - 4)OT")"
            : "\(num)Q"
        quarterNameLabel.text = quarterName
        
        homeScore.text = "\(quarter.homeScore)"
        awayScore.text = "\(quarter.awayScore)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasDrawnBorders {
            views.forEach { $0.addOutline() }
            hasDrawnBorders = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
