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
        let realIndex:Int = Int(index)-1
        if((spaces[realIndex]) != UInt8(0)){
            print("space is taken")
        }
        if(isPlayerX && isPlayerXPlaying) {
            spaces[realIndex] = UInt8(1)
            print("Central move: board is now \(spaces)")
            isPlayerX = !isPlayerX
            //update view controller UI
            
            return true
        }
        else if( (!isPlayerX) && (!isPlayerXPlaying) ) {
            spaces[realIndex] = UInt8(2)
            print("Peripheral move: board is now \(spaces)")
            isPlayerX = !isPlayerX
            //update view controller UI
            return true
        }
        
        return false
        
    }
    
    
    //if three in a row, someone wins
    //if all spaces taken and no win condition = tie
    //else game still ongoing
    func checkGameStatus() {
        
        //board ui layout:
        //789
        //456
        //123
        
        //board logic layout
        //678
        //345
        //012
        
        //flags
        var isFilled:Bool = true
        var xCount:Int = 0
        var oCount:Int = 0
        
        //check each row:
        for i in 0...2 {
            for j in 0...2 {
                let realIndex:Int = i*3 + j
                let value:UInt8 = spaces[realIndex]
                
                //check value
                if(value == UInt8(1)) {
                    xCount += 1
                }
                else if(value == UInt8(2)) {
                    oCount += 1
                }
                else {
                    //no possibility of tie game
                    isFilled = false
                    
                    //since space not filled ... row not worth checking
                    break
                }
            }
            //check if row has winning combo
            if(xCount == 3) {
                status = GameStatus.playerXwin
                //TODO: write to characteristic
            }
            else if(oCount==3) {
                status = GameStatus.playerOwin
                //TODO: write to characteristic
            }
            //else zero out counts
            xCount = 0
            oCount = 0
        }
        
        //check each column
        for m in 0...2 {
            for n in 0...2 {
                let realIndex:Int = m + n*3
                let value:UInt8 = spaces[realIndex]
                
                //check value
                if(value == UInt8(1)) {
                    xCount += 1
                }
                else if(value == UInt8(2)) {
                    oCount += 1
                }
                else {
                    //no possibility of tie game
                    isFilled = false
                    
                    //since space not filled ... row not worth checking
                    break
                }
            }
            //check if row has winning combo
            if(xCount == 3) {
                status = GameStatus.playerXwin
                //TODO: write to characteristic
            }
            else if(oCount==3) {
                status = GameStatus.playerOwin
                //TODO: write to characteristic
            }
            //else zero out counts
            xCount = 0
            oCount = 0
        }
        
        //check bottom left to top right diagonal (indices: 0 4 8)
        for p in 0...2 {
            let realIndex:Int = p*4
            let value:UInt8 = spaces[realIndex]
            
            //check value
            if(value == UInt8(1)) {
                xCount += 1
            }
            else if(value == UInt8(2)) {
                oCount += 1
            }
            else {
                //no possibility of tie game
                isFilled = false
                
                //since space not filled ... row not worth checking
                break
            }
        }
        
        //check if row has winning combo
        if(xCount == 3) {
            status = GameStatus.playerXwin
            //TODO: write to characteristic
        }
        else if(oCount==3) {
            status = GameStatus.playerOwin
            //TODO: write to characteristic
        }
        //else zero out counts
        xCount = 0
        oCount = 0
        
        //check top left to bottom right diagonal (indices: 6 4 2)
        for q in 0...2 {
            let realIndex:Int = 2+q*2
            let value:UInt8 = spaces[realIndex]
            
            //check value
            if(value == UInt8(1)) {
                xCount += 1
            }
            else if(value == UInt8(2)) {
                oCount += 1
            }
            else {
                //no possibility of tie game
                isFilled = false
                
                //since space not filled ... row not worth checking
                break
            }
        }
        
        //check if row has winning combo
        if(xCount == 3) {
            status = GameStatus.playerXwin
            //TODO: write to characteristic
        }
        else if(oCount==3) {
            status = GameStatus.playerOwin
            //TODO: write to characteristic
        }
        //else zero out counts
        xCount = 0
        oCount = 0
        
        ////////////////////////////////////////////////////////////////////////
        
        //check for tie condition:
        if (isFilled) {
            status = GameStatus.tie
            //TODO: write to characteristic
        }
            
            //else game is still ongoing
        else if(status != GameStatus.inProgress) {
            status = GameStatus.inProgress
            //TODO: write to characteristic
        }
        
    }
}
