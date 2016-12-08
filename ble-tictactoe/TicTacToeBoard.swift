//
//  TicTacToeBoard.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/6/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit

enum GameStatus {
    case notStarted
    case inProgress
    case playerXwin
    case playerOwin
    case tie
}

var CurrentGame = TicTacToeBoard()

//Central/LightBlue - Player X
//Peripheral/App - Player O

class TicTacToeBoard {
    
    var spaces : [UInt8] = [0,0,0,0,0,0,0,0,0]
    var isPlayerX: Bool = true
    var status: GameStatus = GameStatus.notStarted
    
    func playerMoved(index: UInt8, isPlayerXPlaying: Bool) -> Bool {
        let realIndex:Int = Int(index)
        if((spaces[realIndex]) == 0){
            //Tell peripheral NO
            return false
        }
        if(isPlayerX && isPlayerXPlaying) {
            spaces[realIndex] = 1
            isPlayerX = !isPlayerX
            //update view controller UI
            
            return true
        }
        else if( (!isPlayerX) && (!isPlayerXPlaying) ) {
            spaces[realIndex] = 2
            isPlayerX = !isPlayerX
            //update view controller UI
            return true
        }
        else {
            // Nothing happens/Not Your Turn
            return false
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
    

}
