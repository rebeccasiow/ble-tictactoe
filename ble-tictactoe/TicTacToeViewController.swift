//
//  TicTacToeViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/5/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

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

    

    @IBAction func playerMoved(_ sender: UIButton) {
        print("Button Pressed")
        
        let moveSuccess: Bool = CurrentGame.playerMoved(index: UInt8(sender.tag), isPlayerXPlaying: false)
        
        if(moveSuccess) {
            playerStatusMessage.text = "You placed a piece!"
        } else {
            playerStatusMessage.text = "Not Your Turn!"
        }
        
    }
    
    @IBOutlet weak var playerTurnLabel: UILabel!
    
    @IBOutlet weak var playerStatusMessage: UILabel!
    
    @IBOutlet weak var gameStatusMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicTacToeViewController viewDidLoad")
        // Do any additional setup after loading the view.
        
        //while(CurrentGame.status !=  GameStatus.playerOwin) {
            
        //}
        
        playerStatusMessage.isHidden = true
        
        
    }
    
    func playerMove(isPlayerX: Bool, coord: Int){

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
