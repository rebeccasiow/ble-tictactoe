//
//  TicTacToeViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/5/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

var TTTVC = TicTacToeViewController()
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
    @IBAction func playerMoved(_ sender: UIButton) {
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
        startGameButton.isHidden = true
        playerStatusMessage.isHidden = false
        playerTurnLabel.isHidden = false
        appPlayerTurn.isHidden = false
        
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicTacToeViewController viewDidLoad")
        // Do any additional setup after loading the view.
        
        //while(CurrentGame.status !=  GameStatus.playerOwin) {
            
        //}
        
        playerStatusMessage.isHidden = true
        playerTurnLabel.isHidden = true
        appPlayerTurn.isHidden = true
        
        
    }
    
    func updateGameStatusMessage(gs:GameStatus) {
        
        switch gs {
        case .inProgress:
            gameStatusMessage.text = "Game In Progress"
        case .notStarted:
            gameStatusMessage.text = "Game Not Started"
        case .playerOwin:
            gameStatusMessage.text = "Player O won!"
        case .playerXwin:
            gameStatusMessage.text = "Player X won!"
        case .tie:
            gameStatusMessage.text = "Game Tie!"
        default:
            gameStatusMessage.text = ""

        }
    
    }
    
    func playerMove(isPlayerX: Bool, coord: Int){
        
        
        
        }
    
    func centralPlayed(index: Int) {
        print("Central Played on Space \(index)")
        
        let button = self.view.viewWithTag(index) as! UIButton
        
            button.setImage(UIImage(named: "x.png"), for: .normal)
        
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
