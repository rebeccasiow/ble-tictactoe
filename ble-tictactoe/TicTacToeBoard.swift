//
//  TicTacToeBoard.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/4/16.
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

class TicTacToeBoard {
    
    var spaces = [Int?]()
    var isPlayerX: Bool = true
    var status: GameStatus = GameStatus.notStarted

    
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
    
    
}
