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
    
    var BoardStateCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: BoardStateCharUUID, properties: [.read, .notify],
        value:nil,
        permissions: .readable)
    
    var PlayerMoveCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: PlayerMoveCharUUID, properties: [.write, .read, .notify], value:nil, permissions: [.readable, .writeable])
    
    var GameStatusCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: GameStatusCharUUID, properties: [.read, .notify], value:nil, permissions: .readable)
    
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
        
        // List of Characteristic UUIDs
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

    
    // Player Move (Central -> Peripheral)
    func playerMove(coord: UInt8) {
        
        if let playerMove = self.PlayerMoveCharacteristic {
            let data = Data(bytes: [coord])
            self.peripheral?.writeValue(data, for: playerMove, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == PlayerMoveCharacteristic {
            // Convert the revived NSData to array of signed 16 bit values
            let byteWritten = characteristic.value
            
            
            
            //parse the data received and display where you want
            
        }
        
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BoardStateCharUUID {
                    self.BoardStateCharacteristic = (characteristic as! CBMutableCharacteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                else if characteristic.uuid == PlayerMoveCharUUID {
                    self.PlayerMoveCharacteristic = (characteristic as! CBMutableCharacteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                }
                else if characteristic.uuid == GameStatusCharUUID {
                    self.GameStatusCharacteristic = (characteristic as! CBMutableCharacteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                }
                
//                // Send notification that Bluetooth is connected and all required characteristics are discovered
//                self.sendBTServiceNotificationWithIsBluetoothConnected(true)
            }
        }
    }
}
