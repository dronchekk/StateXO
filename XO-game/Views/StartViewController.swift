//
//  StartViewController.swift
//  XO-game
//
//  Created by Andrey Rachitskiy on 11.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

public enum GameType: Int, Hashable, Equatable, CaseIterable {

    case two = 0
    case pk
    case fiveinarow
}

class StartViewController: UIViewController {

    @IBOutlet weak var twoGame: UIButton!
    @IBOutlet weak var pkGame: UIButton!
    @IBOutlet weak var game: UIButton!

    private var gameType: GameType = .two

    @IBAction func didTouchButton(_ sender: UIButton) {
//        Main.storyboard
        if twoGame === sender {
            gameType = .two
        } else if pkGame === sender {
            gameType = .pk
        } else if game === sender {
            gameType = .fiveinarow
        }
        openGameViewController()
    }

    func openGameViewController() {
        let stor = UIStoryboard(name: "Main", bundle: .main)
        guard let gameViewController = stor.instantiateViewController(withIdentifier: String(describing: GameViewController.self)) as? GameViewController else { return }
        gameViewController.gameType = gameType
        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
