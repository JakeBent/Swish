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
            boxScoreView?.setup(with: boxscore)
        }
    }
    
    let game: Game
    weak var boxScoreView: BoxScoreView?
    weak var parent: GameDetailViewController?
    var didFinishLoading: (() -> Void)?
    
    init(_ parent: GameDetailViewController, boxScoreView: BoxScoreView, game: Game, didFinishLoading: (() -> Void)?) {
        self.parent = parent
        self.game = game
        self.boxScoreView = boxScoreView
        self.didFinishLoading = didFinishLoading
        super.init()
        
        NBAService.shared.getBoxscore(id: game.id) { [weak self] err, boxScore in
            self?.boxscore = boxScore
            
            self?.didFinishLoading?()
        }
    }
    
}
