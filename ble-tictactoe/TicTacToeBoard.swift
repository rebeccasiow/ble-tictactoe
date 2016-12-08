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
    case playerXwin
    case playerOwin
    case tie
    case inProgress
}

var CurrentGame = TicTacToeBoard()  //provide global reference to board for TTTViewController and DeviceScanPeripheral

//REFERENCE:
//Central/LightBlue - Player X
//Peripheral/App - Player O

class TicTacToeBoard {
    
    var spaces : [UInt8] = [0,0,0,0,0,0,0,0,0]     //tictactoe board in array form: 0-8 indices corres. to 1-9 keypad input on LightBlue
    var isPlayerX: Bool = true  //whose turn
    var status: GameStatus = GameStatus.notStarted
    var statusChanged: Bool = false   //conditional flag for characteristic update
    
    var playerXLastMove: Int = 0
    
    func playerMoved(index: UInt8, isPlayerXPlaying: Bool) -> Bool {
        let realIndex:Int = Int(index)-1
        if((spaces[realIndex]) != UInt8(0)){
            print("space is taken")
        }
        else if(isPlayerX && isPlayerXPlaying) {    //Central's move (Player X)
            spaces[realIndex] = UInt8(1)
            print("Central move: board is now \(spaces)")
            isPlayerX = !isPlayerX
            
            playerXLastMove = Int(index)
            NotificationCenter.default.post(name: Notification.Name(rawValue: TTTVC_CM), object:nil) //update view controller UI
            return true
        }
        else if( (!isPlayerX) && (!isPlayerXPlaying) ) {    //Peripheral's move (Player O)
            spaces[realIndex] = UInt8(2)
            print("Peripheral move: board is now \(spaces)")
            isPlayerX = !isPlayerX
            NotificationCenter.default.post(name: Notification.Name(rawValue: PM_PM), object:nil)
            
            //view controller updates UI by itself
            return true
        }
        return false
    }
    
    
    //if three in a row, someone wins
    //if all spaces taken and no win condition = tie
    //else game still ongoing
    func checkGameStatus() {
        
        //board ui layout:      //board logic layout
        //789                   //678
        //456                   //345
        //123                   //012
        
        
        //flags and counters
        var isFilled:Bool = true
        var xCount:Int = 0
        var oCount:Int = 0
        
        //check each row:
        print("checking rows")
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
                }
            }
            if(checkForWin(xCount: xCount, oCount: oCount)) {
                return
            }
            //else zero out counts
            xCount = 0
            oCount = 0
        }
        
        xCount = 0
        oCount = 0
        
        //check each column
        print("checking columns")
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
                }
            }
            if(checkForWin(xCount: xCount, oCount: oCount)) {
                return
            }
            //else zero out counts
            xCount = 0
            oCount = 0
        }
        
        xCount = 0
        oCount = 0
        
        //check bottom left to top right diagonal (indices: 0 4 8)
        print("checking diagonal 1")
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
            }
        }
        
        if(checkForWin(xCount: xCount, oCount: oCount)) {
            return
        }
        //else zero out counts
        xCount = 0
        oCount = 0
        
        //check top left to bottom right diagonal (indices: 6 4 2)
        print("checking diagonal 2")
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
            }
        }
        
        if(checkForWin(xCount: xCount, oCount: oCount)) {
            return
        }
        
        //////End Board Checks//////
        
        //check for tie condition:
        if (isFilled) {
            print ("tie game determined")
            status = GameStatus.tie
            NotificationCenter.default.post(name: Notification.Name(rawValue: TTTVC_GS), object:nil)
            statusChanged = true
            return
        }
            
            //else game is still ongoing
        else if(status != GameStatus.inProgress) {
            print ("setting game to in progress")
            status = GameStatus.inProgress
            NotificationCenter.default.post(name: Notification.Name(rawValue: TTTVC_GS), object:nil)
            statusChanged = true
            return
        }
        
    }
    
    func checkForWin(xCount: Int, oCount: Int) -> Bool {
        if(xCount == 3) {
            status = GameStatus.playerXwin
            NotificationCenter.default.post(name: Notification.Name(rawValue: TTTVC_GS), object:nil)
            statusChanged = true
            return true
        }
        else if(oCount==3) {
            status = GameStatus.playerOwin
            NotificationCenter.default.post(name: Notification.Name(rawValue: TTTVC_GS), object:nil)
            statusChanged = true
            return true
        }
        return false
    }
}
