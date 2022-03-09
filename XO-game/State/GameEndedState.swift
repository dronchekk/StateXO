//
//  GameEndedState.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 17.02.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class GameEndedState: GameState {
    
    // MARK: - Public Properties
    
    var isCompleted: Bool = false
    let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    
    // MARK: - Construction
    
    init(winner: Player?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    // MARK: - Functions
    
    func begin() {
        log(.gameFinished(winner: winner))
        
        gameViewController?.winnerLabel.isHidden = false
        
        if let winner = winner {
            gameViewController?.winnerLabel.text = winnerName(from: winner) + " win"
        } else {
            gameViewController?.winnerLabel.text = "No winner"
        }
        
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) { }
    
    // MARK: - Private Functions
    
    func winnerName(from winner: Player) -> String {
        switch winner {
        case .first:
            return "1st player"
        case .second:
            return "2nd player"
        }
    }
}
