//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var gameType: GameType = .two

    // MARK: - Outlets
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    // MARK: - Private Properties
    
    private lazy var referee = Referee(gameboard: gameboard)

    private let allPositions: Set<GameboardPosition> = [
        .init(column: 0, row: 0), .init(column: 0, row: 1), .init(column: 0, row: 2),
        .init(column: 1, row: 0), .init(column: 1, row: 1), .init(column: 1, row: 2),
        .init(column: 2, row: 0), .init(column: 2, row: 1), .init(column: 2, row: 2)
    ]

    private lazy var availablePositions: Set<GameboardPosition> = {
        return allPositions
    }()

    /// Счетчик шагов. значения от 0 до 4. Если -1, то игрок не ходил неразу
    private var pointCount: Int = -1
    private var firstPositionList: [GameboardPosition]?
    private var secondPositionList: [GameboardPosition]?

    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else {
                return
            }

            switch self.gameType {
            case .two:
                self.currentState.addMark(at: position)

                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            case .pk:
                self.tabHandlerIn(position: position)
            case .fiveinarow:
                if self.firstPositionList == nil {
                    self.firstPositionList = []
                    self.secondPositionList = []
                }

                let firstRange = 0 ... 4
                let secondRange = 5 ... 9
                self.pointCount += 1

                if firstRange.contains(self.pointCount) {
                    self.firstPlayerTurnLabel.isHidden = false
                    self.secondPlayerTurnLabel.isHidden = true
                    self.firstPositionList?.append(position)

                    if self.pointCount == firstRange.upperBound {
                        self.firstPlayerTurnLabel.isHidden = true
                        self.secondPlayerTurnLabel.isHidden = false
                    }
                }

                if secondRange.contains(self.pointCount) {
                    self.firstPlayerTurnLabel.isHidden = true
                    self.secondPlayerTurnLabel.isHidden = false
                    self.secondPositionList?.append(position)

                    if secondRange.upperBound == self.pointCount {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.play()
                        }
                    }
                }
            }

        }
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        log(.restartGame)
    }
    
    // MARK: - Private Functions
    
    private func goToFirstState() {
        let player = Player.first
        currentState = PlayerInputState(player: .first,
                                        markViewPrototype: player.markViewPrototype,
                                        gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(player: player,
                                            markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)

            if player == .second, gameType == .pk {
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) { [weak self] in
                    guard let self = self, let position = self.availablePositions.randomElement() else {
                        return
                    }
                    self.tabHandlerIn(position: position)
                }
            }
        }
    }

    private func tabHandlerIn(position: GameboardPosition) {
        currentState.addMark(at: position)
        availablePositions.remove(position)

        if currentState.isCompleted {
            goToNextState()
        }
    }

    private func play() {
        let range: ClosedRange<Int> = 0 ... 4
        var resultPositionList: [GameboardPosition] = []
        for index in range {
            resultPositionList.append(firstPositionList![index])
            resultPositionList.append(secondPositionList![index])
        }

        for position in resultPositionList {
            if let playerInputState = currentState as? PlayerInputState {
                if !gameboardView.canPlaceMarkView(at: position) {
                    gameboardView.removeMarkView(at: position)
                }
                currentState.addMark(at: position)
                let player = playerInputState.player.next
                currentState = PlayerInputState(player: player,
                                                markViewPrototype: player.markViewPrototype,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
            }
        }
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
        }
    }
}

