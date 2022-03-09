//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Alexander Rubtsov on 17.02.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

class PlayerInputState: GameState {
    
    // MARK: - Properties
    let markViewPrototype: MarkView
    
    private(set) var isCompleted: Bool = false
    let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    // MARK: - Construction
    
    init(player: Player,
         markViewPrototype: MarkView,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    // MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        log(.playerInput(player: player, position: position))
        
        guard let gameboardView = gameboardView, gameboardView.canPlaceMarkView(at: position) else {
            return
        }
        
        //let markView: MarkView = player == .first ? XView() : OView()
        
        gameboard?.setPlayer(player, at: position)
        gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
}
