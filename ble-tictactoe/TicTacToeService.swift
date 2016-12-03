//
//  TicTacToeService.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/2/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 Creating Custom UUIDs for our TicTacToe Service
 **/

let TicTacToeServiceUUID = CBUUID(string: "6BC2F6D4-570C-4709-81FD-3535F128CAD7")
let BoardStateCharUUID = CBUUID(string: "994416DF-115E-406E-AE40-DD4261D7FCAC")
let PlayerMoveCharUUID = CBUUID(string: "1D386F1E-FFA6-4FE3-BCE1-FE93DB2FC2B3")
let GameStatusCharUUID = CBUUID(string: "7666BFE8-B201-45B7-8FAB-0C95A9A9A1F3")

let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"

class TicTacToeService: NSObject, CBPeripheralDelegate {
    
    var peripheral: CBPeripheral?
    var BoardStateCharacteristic: CBCharacteristic?
    var PlayerMoveCharacteristic: CBCharacteristic?
    var GameStatusCharacteristic: CBCharacteristic?
    
    init(initWithPeripheral peripheral: CBPeripheral) {
        
        super.init()
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        
    }
    
    // Allows Peripherals to find TicTacToeService
    func beginServiceDiscover() {
        self.peripheral?.discoverServices([TicTacToeServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        let uuidList: [CBUUID] = [BoardStateCharUUID, PlayerMoveCharUUID, GameStatusCharUUID]
        
        if (peripheral != self.peripheral) {
            // this is not the peripheral you are looking for
            return
        }
        
        if (error != nil) {
            //we got an error (how to examine?)
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            //no services available
            return
        }
        
        //iterate thru available services and find tictactoe
        for service in peripheral.services! {
            if service.uuid == TicTacToeServiceUUID {
                peripheral.discoverCharacteristics(uuidList, for: service)
            }
        }
        
    }


}
