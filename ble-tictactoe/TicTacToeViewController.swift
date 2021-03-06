//
//  TicTacToeViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/5/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

let TTTVC_CM = "TTTVC.CentralMovedNotificationKey"
let TTTVC_GS = "TTTVC.GameStatusNotificationKey"



class TicTacToeViewController: UIViewController {
    
    @IBOutlet weak var space7: UIButton!
    @IBOutlet weak var space8: UIButton!
    @IBOutlet weak var space9: UIButton!
    
    @IBOutlet weak var space4: UIButton!
    @IBOutlet weak var space5: UIButton!
    @IBOutlet weak var space6: UIButton!
    
    @IBOutlet weak var space1: UIButton!
    @IBOutlet weak var space2: UIButton!
    @IBOutlet weak var space3: UIButton!
    
    @IBOutlet weak var playerTurnLabel: UILabel!
    
    @IBOutlet weak var appPlayerTurn: UILabel!
    @IBOutlet weak var playerStatusMessage: UILabel!
    
    @IBOutlet weak var gameStatusMessage: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var NewGameButton: UIButton!
    
    @IBOutlet weak var IntroView: UILabel!
    
    @IBAction func playerMoved(_ sender: UIButton) {
        
        if((CurrentGame.status == GameStatus.playerXwin)||(CurrentGame.status == GameStatus.playerOwin) || (CurrentGame.status == GameStatus.tie)) {
            playerStatusMessage.text = "Game Over!"
            return
        }
        
        print("\(sender.tag) Button Pressed")
        
        let moveSuccess: Bool = CurrentGame.playerMoved(index: UInt8(sender.tag), isPlayerXPlaying: false)
        
        if(moveSuccess) {
            sender.setImage(UIImage(named: "o.png"), for: .normal)
                        playerStatusMessage.text = "You placed a piece!"
        } else {
            playerStatusMessage.text = "Not Your Turn!"
        }
        
    }
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        NewGameStarted()
        IntroView.isHidden = true
    }
    
    func NewGameStarted() {
        print("New Game Started")
        startGameButton.isHidden = true
        playerStatusMessage.isHidden = false
        playerTurnLabel.isHidden = false
        appPlayerTurn.isHidden = false
        NewGameButton.isHidden = true
        
        playerTurnLabel.text = "Player X's Turn"
        playerStatusMessage.text = "Started game!"
        gameStatusMessage.text = "Game In Progress"
        
        space1.setImage(nil, for: .normal)
        space2.setImage(nil, for: .normal)
        space3.setImage(nil, for: .normal)
        space4.setImage(nil, for: .normal)
        space5.setImage(nil, for: .normal)
        space6.setImage(nil, for: .normal)
        space7.setImage(nil, for: .normal)
        space8.setImage(nil, for: .normal)
        space9.setImage(nil, for: .normal)
        
        CurrentGame = TicTacToeBoard()
        CurrentGame.status = GameStatus.inProgress
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicTacToeViewController viewDidLoad")
        // Do any additional setup after loading the view.
        NewGameButton.isHidden = true
        playerStatusMessage.isHidden = true
        playerTurnLabel.isHidden = true
        appPlayerTurn.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.centralPlayed), name: NSNotification.Name(rawValue: TTTVC_CM), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TicTacToeViewController.updateGameStatusMessage), name: NSNotification.Name(rawValue: TTTVC_GS), object: nil)
    }
    
    /**
     Updates Game Status Message on UI
     **/
    func updateGameStatusMessage() {
        switch CurrentGame.status {
        case .inProgress:
            gameStatusMessage.text = "Game In Progress"
        case .notStarted:
            gameStatusMessage.text = "Game Not Started"
        case .playerOwin:
            gameStatusMessage.text = "Player O won!"
            NewGameButton.isHidden = false
        case .playerXwin:
            gameStatusMessage.text = "Player X won!"
            NewGameButton.isHidden = false
        case .tie:
            gameStatusMessage.text = "Game Tie!"
            NewGameButton.isHidden = false
        default:
            gameStatusMessage.text = "???"

        }
    }
    
    /** Updates UI if Central Played **/
    func centralPlayed() {
        
        let index:Int = CurrentGame.playerXLastMove
        
        print("Central Played on Space \(index)")
        
        let button = self.view.viewWithTag(index) as! UIButton
        
            button.setImage(UIImage(named: "x.png"), for: .normal)
        
        gameStatusMessage.text = "Opponent Placed a Piece!"
        playerStatusMessage.text = ""

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
