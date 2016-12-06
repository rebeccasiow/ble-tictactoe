//
//  TicTacToeViewController.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/5/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

var OurScan = DeviceScan()

enum GameStatus {
    case notStarted
    case inProgress
    case playerXwin
    case playerOwin
    case tie
}

var spaces = [Int?]()
var isPlayerX: Bool = true
var status: GameStatus = GameStatus.notStarted


class TicTacToeViewController: UIViewController {

    @IBOutlet weak var space0: UIImageView!
    
    @IBOutlet weak var space1: UIImageView!
    
    @IBOutlet weak var space2: UIImageView!
    
    @IBOutlet weak var space3: UIImageView!
    
    @IBOutlet weak var space4: UIImageView!
    
    @IBOutlet weak var space5: UIImageView!
    
    @IBOutlet weak var space6: UIImageView!
    
    @IBOutlet weak var space7: UIImageView!
    
    @IBOutlet weak var space8: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        space0.image = nil
        space1.image = nil
        space2.image = nil
        space3.image = nil
        space4.image = nil
        space5.image = nil
        space6.image = nil
        space7.image = nil
        space8.image = nil
        
        // Do any additional setup after loading the view.
        
        while(CurrentGame.status !=  GameStatus.playerOwin) {
            
        }
        
    }
    

    
        
        
        func playerMove(isPlayerX: Bool, coord: Int){
            
            let elem = spaces[coord]
            
            //check if spot taken
            if(elem != nil) {
                //space taken biatch
                //notify user that you can't take that
            }
            else {
                if(isPlayerX) {
                    spaces[coord] = 1
                }
                else {
                    spaces[coord] = 2
                }
                
                //check game status
                checkGameStatus()
                self.isPlayerX = !isPlayerX
                
                //write to characteristics
                //board state, gamestatus
                
                moveNotif = true
                
            }
        }
        
        //if three in a row, someone wins
        //if all spaces taken and no win condition = tie
        //else game still ongoing
        func checkGameStatus() {
            
            let boardLen = spaces.count
            
            //012
            //345
            //678
            
            if((spaces[0] == spaces[1] && spaces[1] == spaces[2])){
                if(spaces[0] == 1) {
                    status = GameStatus.playerXwin
                    
                }
                else if(spaces[0] == 2) {
                    status = GameStatus.playerOwin
                }
            }
            if((spaces[3] == spaces[4] && spaces[4] == spaces[5])){
                if(spaces[3] == 1) {
                    status = GameStatus.playerXwin
                }
                else if(spaces[3] == 2)  {
                    status = GameStatus.playerOwin
                }
            }
            if((spaces[6] == spaces[7] && spaces[7] == spaces[8])){
                if(spaces[6] == 1) {
                    status = GameStatus.playerXwin
                }
                else if(spaces[6] == 2)  {
                    status = GameStatus.playerOwin
                }
            }
            
            //TODO columns and diagonals
            
            if((spaces[0] == spaces[1] && spaces[1] == spaces[2])){
                if(spaces[0] == 1) {
                    status = GameStatus.playerXwin
                    
                }
                else if(spaces[0] == 2) {
                    status = GameStatus.playerOwin
                }
            }
            if((spaces[3] == spaces[4] && spaces[4] == spaces[5])){
                if(spaces[3] == 1) {
                    status = GameStatus.playerXwin
                }
                else if(spaces[3] == 2)  {
                    status = GameStatus.playerOwin
                }
            }
            if((spaces[6] == spaces[7] && spaces[7] == spaces[8])){
                if(spaces[6] == 1) {
                    status = GameStatus.playerXwin
                }
                else if(spaces[6] == 2)  {
                    status = GameStatus.playerOwin
                }
            }
            
            
            
            
            //Tie Condition
            
            
            //end: update game status characteristic
            
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
