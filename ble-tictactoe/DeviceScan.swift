//
//  DeviceScan.swift
//  ble-tictactoe
//
//  Created by Rebecca Siow on 12/2/16.
//  Copyright © 2016 Rebecca Siow. All rights reserved.
//

import Foundation
import CoreBluetooth

let deviceDis


class DeviceScan: NSObject, CBCentralManagerDelegate {

    fileprivate var centralManager: CBCentralManager?
    fileprivate var peripheralFound: CBPeripheral?
    
    var TicTacToeservice: TicTacToeService?
    
    //Initializing Central Manager
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
        
        /*!
         *  @method centralManagerDidUpdateState:
         *
         *  @param central  The central manager whose state has changed.
         *
         *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
         *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
         *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
         *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
         *                  manager become invalid and must be retrieved or discovered again.
         *
         *  @see            state
         *
         */
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            self.clearDevices()
            
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case .unknown:
            // Wait for another event
            break
            
        case .poweredOn:
            self.startScanning()
            
        case .resetting:
            self.clearDevices()
            
        case .unsupported:
            break
        }
    }
    
    func clearDevices() {
        self.TicTacToeservice = nil
        self.peripheralFound = nil
    }
    
    func startScanning() {
        if let centralExists = centralManager {
            centralExists.scanForPeripherals(withServices: [TicTacToeServiceUUID], options: nil)
        }
        
    }
        
        /*!
         *  @method centralManager:willRestoreState:
         *
         *  @param central      The central manager providing this information.
         *  @param dict			A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
         *
         *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
         *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
         *						Bluetooth system.
         *
         *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
         *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
         *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
         *
         */
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
        
    
    
    }
        
        /*!
         *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
         *
         *  @param central              The central manager providing this update.
         *  @param peripheral           A <code>CBPeripheral</code> object.
         *  @param advertisementData    A dictionary containing any advertisement and scan response data.
         *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
         *								was not available.
         *
         *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
         *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
         *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
         *
         *  @seealso                    CBAdvertisementData.h
         *
         */
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //check peripheral validity
        if((peripheral.name == nil) || (peripheral.name == "") ) {
            return
        }
        
        //if there isn't a peripheral, connect
        
        if ((self.peripheralFound == nil) || (self.peripheralFound?.state == CBPeripheralState.disconnected)) {
            // Retain the peripheral before trying to connect
            self.peripheralFound = peripheral
            
            // Reset service
            self.TicTacToeservice = nil
            
            // Connect to peripheral
            central.connect(peripheral, options: nil)
        }
        
        
        /*!
         *  @method centralManager:didConnectPeripheral:
         *
         *  @param central      The central manager providing this information.
         *  @param peripheral   The <code>CBPeripheral</code> that has connected.
         *
         *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
         *
         */
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            
            //Instanciate TTTService
            if (peripheral == self.peripheralFound) {
                self.TicTacToeservice = TicTacToeService(initWithPeripheral: peripheral)
            }
            
            // Stop scanning for new devices
            central.stopScan()

        
        }
        
        
        /*!
         *  @method centralManager:didFailToConnectPeripheral:error:
         *
         *  @param central      The central manager providing this information.
         *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
         *  @param error        The cause of the failure.
         *
         *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
         *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
         *
         */
        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            
            self.clearDevices()
            
        }
        
        
        /*!
         *  @method centralManager:didDisconnectPeripheral:error:
         *
         *  @param central      The central manager providing this information.
         *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
         *  @param error        If an error occurred, the cause of the failure.
         *
         *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
         *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
         *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
         *
         */
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            
            // See if it was our peripheral that disconnected
            if (peripheral == self.peripheralFound) {
                self.clearDevices()
            }
            
            // Start scanning for new devices
            self.startScanning()
        
        }
    }




}
