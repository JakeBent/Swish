//
//  GameDetailDataSource.swift
//  Swish
//
//  Created by Jacob Benton on 2/17/20.
//  Copyright © 2020 Jacob Benton. All rights reserved.
//

import UIKit

class GameDetailDataSource: NSObject {

    var boxscore: Boxscore? {
        didSet {
            parent?.boxScore.setup(with: boxscore)
            parent?.gameCell.setup(withBoxscore: boxscore)
            parent?.scoringOverview.setup(with: boxscore)
            parent?.playByPlay.setup(with: boxscore)
            let animations = parent?.teamComparison.setup(with: boxscore)
            parent?.exec(animations: animations ?? [])
        }
    }
    
    let game: Game
    weak var parent: GameDetailViewController?
    var didFinishLoading: (() -> Void)?
    
    init(_ parent: GameDetailViewController, game: Game, didFinishLoading: (() -> Void)?) {
        self.parent = parent
        self.game = game
        self.didFinishLoading = didFinishLoading
        super.init()
        
        NBAService.shared.getBoxscore(id: game.id, progress: { progress in
            self.parent?.view.setProgress(progress)
        }) { [weak self] err, boxScore in
            self?.boxscore = boxScore
            
            self?.didFinishLoading?()
        }
    }
    
}
