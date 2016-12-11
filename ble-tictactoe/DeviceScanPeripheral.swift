//
//  DeviceScanPeripheral.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/6/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import UIKit
import CoreBluetooth

/**
 TicTacToeService Setup: Creating Custom UUIDs for our TicTacToe Service
 **/

let TicTacToeServiceUUID = CBUUID(string: "6BC2F6D4-570C-4709-81FD-3535F128CAD7")
let BoardStateCharUUID = CBUUID(string: "994416DF-115E-406E-AE40-DD4261D7FCAC")
let PlayerMoveCharUUID = CBUUID(string: "1D386F1E-FFA6-4FE3-BCE1-FE93DB2FC2B3")
let GameStatusCharUUID = CBUUID(string: "7666BFE8-B201-45B7-8FAB-0C95A9A9A1F3")

/**
 Storing values for Readable characteristics
 - BoardStateCharacteristic: Sends an array of Unsigned Integers corresponding to the status of each board space.
 - GameStatusCharacteristic: Sends the game status enum, who's turn it is, the symbol the player is assigned("X")
 **/
var payload = Data(bytes: CurrentGame.spaces)
var message = Data(bytes: [UInt8(0), CurrentGame.isPlayerX ? UInt8(1):UInt8(2), UInt8(1)])    //1st: game status enum; 2nd: whose_turn; 3rd: who_am_i

//Using NSNotificationCenter to inform the TicTacToeViewController about valid player moves from the central.
let PM_PM = "PMPM.NotificationKey"


/**
 
 DeviceScanPeripheral
 
 Class Overview: Configuration of the iOS app as the Peripheral Server,
 whereby another device running LightBlue would connect as a Central.
 The app broadcasts the TicTacToeService for LightBlue to discover and
 connect to using the CBPeripheralManagerDelegate protocol.
 
 **/

class DeviceScanPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    var thePeripheralManager: CBPeripheralManager!
    
    /**Configuration of Service Characteristic Properties**/

    var TicTacToeService:CBMutableService = CBMutableService(type: TicTacToeServiceUUID, primary: true)
    
    var BoardStateCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: BoardStateCharUUID, properties: [.read, .notify], value:nil, permissions: .readable)
    
    var PlayerMoveCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: PlayerMoveCharUUID, properties: [.write], value:nil, permissions: [.readable, .writeable])
    
    var GameStatusCharacteristic: CBMutableCharacteristic? = CBMutableCharacteristic(type: GameStatusCharUUID, properties: [.read, .notify], value:nil, permissions: .readable)
    
    var advertisementData = [String:Any]()
    
    /**Initializing Peripheral Manager**/
    override init() {
        super.init()
        print("PeripheralManager init")
        
        thePeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        // Broadcast as TTTPeripheral
        advertisementData = [CBAdvertisementDataLocalNameKey: "TTTPeripheral", CBAdvertisementDataServiceUUIDsKey:[TicTacToeServiceUUID]]
        
        TicTacToeService.characteristics = [BoardStateCharacteristic!, PlayerMoveCharacteristic!, GameStatusCharacteristic!]
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeviceScanPeripheral.updateBoard), name: NSNotification.Name(rawValue: PM_PM), object: nil)    }
    
    
    /*!
     *  @method peripheralManagerDidUpdateState:
     *
     *  @param peripheral   The peripheral manager whose state has changed.
     *
     *  @discussion         Invoked whenever the peripheral manager's state has been updated. Commands should only be issued when the state is
     *                      <code>CBPeripheralManagerStatePoweredOn</code>. A state below <code>CBPeripheralManagerStatePoweredOn</code>
     *                      implies that advertisement has paused and any connected centrals have been disconnected. If the state moves below
     *                      <code>CBPeripheralManagerStatePoweredOff</code>, advertisement is stopped and must be explicitly restarted, and the
     *                      local database is cleared and all services must be re-added.
     *
     *  @see                state
     *
     */
    
    
    public func peripheralManagerDidUpdateState(_ Peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
        
        switch (Peripheral.state) {
        case .poweredOff:
            thePeripheralManager?.stopAdvertising()
            
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case .unknown:
            // Wait for another event
            break
            
        case .poweredOn:
            print("Peripheral Powered On/Started Advertising")
            thePeripheralManager.add(TicTacToeService)
            thePeripheralManager.startAdvertising(advertisementData)
            
        case .resetting:
            thePeripheralManager.stopAdvertising()
            
        case .unsupported:
            break
        }
    }
    
    /*!
     *  @method peripheralManager:willRestoreState:
     *
     *  @param peripheral	The peripheral manager providing this information.
     *  @param dict			A dictionary containing information about <i>peripheral</i> that was preserved by the system at the time the app was terminated.
     *
     *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
     *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
     *						Bluetooth system.
     *
     *  @seealso            CBPeripheralManagerRestoredStateServicesKey;
     *  @seealso            CBPeripheralManagerRestoredStateAdvertisementDataKey;
     *
     */
    public func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    /*!
     *  @method peripheralManagerDidStartAdvertising:error:
     *
     *  @param peripheral   The peripheral manager providing this information.
     *  @param error        If an error occurred, the cause of the failure.
     *
     *  @discussion         This method returns the result of a @link startAdvertising: @/link call. If advertisement could
     *                      not be started, the cause will be detailed in the <i>error</i> parameter.
     *
     */
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising")
        
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        print("Succeeded!")
        
    }
    
    
    /*!
     *  @method peripheralManager:didAddService:error:
     *
     *  @param peripheral   The peripheral manager providing this information.
     *  @param service      The service that was added to the local database.
     *  @param error        If an error occurred, the cause of the failure.
     *
     *  @discussion         This method returns the result of an @link addService: @/link call. If the service could
     *                      not be published to the local database, the cause will be detailed in the <i>error</i> parameter.
     *
     */
    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?){
        print("didAddService")
        
        if let error = error {
            print("Service Add Failed: \(error)")
            return
        }
        print("Service:\(service)")
        
        
    }
    
    
    /*!
     *  @method peripheralManager:central:didSubscribeToCharacteristic:
     *
     *  @param peripheral       The peripheral manager providing this update.
     *  @param central          The central that issued the command.
     *  @param characteristic   The characteristic on which notifications or indications were enabled.
     *
     *  @discussion             This method is invoked when a central configures <i>characteristic</i> to notify or indicate.
     *                          It should be used as a cue to start sending updates as the characteristic value changes.
     *
     */
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic){
    }
    
    
    /*!
     *  @method peripheralManager:central:didUnsubscribeFromCharacteristic:
     *
     *  @param peripheral       The peripheral manager providing this update.
     *  @param central          The central that issued the command.
     *  @param characteristic   The characteristic on which notifications or indications were disabled.
     *
     *  @discussion             This method is invoked when a central removes notifications/indications from <i>characteristic</i>.
     *
     */
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        
        
    }
    
    
    /*!
     *  @method peripheralManager:didReceiveReadRequest:
     *
     *  @param peripheral   The peripheral manager requesting this information.
     *  @param request      A <code>CBATTRequest</code> object.
     *
     *  @discussion         Checks which characteristic is being read and relays data back.
     *
     */
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceiveRead")
        
        let characteristicUUID = request.characteristic.uuid
        
        if(characteristicUUID.isEqual(PlayerMoveCharacteristic?.uuid)){
            request.value = PlayerMoveCharacteristic?.value
            peripheral.respond(to: request, withResult: .success)
        }
        else if(characteristicUUID.isEqual(GameStatusCharacteristic?.uuid)){
            print("GameStatus Read")
            messageUpdate()
            request.value = message
            peripheral.respond(to: request, withResult: .success)
        }
        else if(characteristicUUID.isEqual(BoardStateCharacteristic?.uuid)){
            print("BoardState Read")
            payloadUpdate()
            request.value = payload
            peripheral.respond(to: request, withResult: .success)
        }
    }
    
    /*!
     *  @method peripheralManager:didReceiveWriteRequests:
     *
     *  @param peripheral   The peripheral manager requesting this information.
     *  @param requests     A list of one or more <code>CBATTRequest</code> objects.
     *
     *  @discussion         This method is invoked when <i>peripheral</i> receives an ATT request or command for one or more characteristics with a dynamic value.
     *                      For every invocation of this method, @link respondToRequest:withResult: @/link should be called exactly once. If <i>requests</i> contains
     *                      multiple requests, they must be treated as an atomic unit. If the execution of one of the requests would cause a failure, the request
     *                      and error reason should be provided to <code>respondToRequest:withResult:</code> and none of the requests should be executed.
     *
     *  @see                CBATTRequest
     *
     */
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("DidReceiveWrite")

        for request in requests {
            if (request.characteristic.uuid.isEqual(PlayerMoveCharacteristic?.uuid)) {
                
                if((CurrentGame.status == GameStatus.playerXwin)||(CurrentGame.status == GameStatus.playerOwin) || (CurrentGame.status == GameStatus.tie)) {
                    peripheral.respond(to: request, withResult: .writeNotPermitted)
                    return
                }
                
                guard let byteWritten = request.value else {
                    print("Null Data Received")
                    return
                }
                
                let byteInt: UInt8 = byteWritten.first!
                print("byteInt: \(byteInt)")
                
                if(byteInt < 1 || byteInt > 9) {
                    print("Input out of range. 1 for player X, 2 for player O")
                    return
                }
                
                let moveSuccess = CurrentGame.playerMoved(index: byteInt, isPlayerXPlaying: true)
                if(moveSuccess) {
                    peripheral.respond(to: request, withResult: .success)
                    updateBoard()
                }
                else {
                    peripheral.respond(to: request, withResult: .writeNotPermitted)
                }
            }
        }
    }
    /*!
     *  @method peripheralManagerIsReadyToUpdateSubscribers:
     *
     *  @param peripheral   The peripheral manager providing this update.
     *
     *  @discussion         This method is invoked after a failed call to @link updateValue:forCharacteristic:onSubscribedCentrals: @/link, when <i>peripheral</i> is again
     *                      ready to send characteristic value updates.
     *
     */
    
    public func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager){
        updateStatus()
    }
    
    /**
     Updates the UInt8 array for Board State Characteristic
     **/
    public func payloadUpdate() {
        print("Board is now: \(CurrentGame.spaces)")
        payload = Data(bytes: CurrentGame.spaces)
    }
    
    /**
     Updates the Game Status
     **/
    public func messageUpdate() {
        
        let turn: UInt8 = CurrentGame.isPlayerX ? UInt8(1):UInt8(2)
        var statusValue: UInt8
        
        switch CurrentGame.status {
        case GameStatus.notStarted:
            statusValue = UInt8(0)
        case GameStatus.playerXwin:
            statusValue = UInt8(1)
        case GameStatus.playerOwin:
            statusValue = UInt8(2)
        case GameStatus.tie:
            statusValue = UInt8(3)
        case GameStatus.inProgress:
            statusValue = UInt8(4)
        default:
            statusValue = UInt8(9) //unknown
            break
        }
        
        print ("message update ... status value is \(statusValue) and it is player \(turn)'s turn")
        message = Data(bytes: [statusValue, turn, UInt8(1)])
    }
    
    /**
     Updates Board State Characteristic
     **/
    public func updateBoard() {
        
        payloadUpdate()
        if(thePeripheralManager.updateValue(payload, for: BoardStateCharacteristic!, onSubscribedCentrals: nil)) {
            print("Board Update Success")
            CurrentGame.checkGameStatus()
            updateStatus()
        }
        else {
            print("Board Char Failed to Update")
        }
        
    }
    
    /**
     Updates Game Status Characteristic
     **/
    public func updateStatus() {
        if (CurrentGame.statusChanged) {
            messageUpdate()
            if(thePeripheralManager.updateValue(message, for: GameStatusCharacteristic!, onSubscribedCentrals: nil)) {
                print("Game status updated to: \(CurrentGame.status)")
                CurrentGame.statusChanged = false
            }
            else {
                print("Game status update fail")
            }
        }
    }
    
}
