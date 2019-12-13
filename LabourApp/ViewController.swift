//
//  ViewController.swift
//  LabourApp
//
//  Created by Umair Afzal on 12/12/2019.
//  Copyright © 2019 Umair Afzal. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController {
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        initLocalBeacon()
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        stopLocalBeacon()
    }
    
    @IBAction func becomeListenerButtonTapped(_ sender: Any) {
        stopLocalBeacon()
    }
}

extension ViewController: CBPeripheralManagerDelegate {
    
    // creates the beacon and starts broadcasting
    func initLocalBeacon() {
        
        if localBeacon != nil {
            stopLocalBeacon()
        }

        let localBeaconUUID = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
        let localBeaconMajor: CLBeaconMajorValue = 123
        let localBeaconMinor: CLBeaconMinorValue = 456

        let uuid = UUID(uuidString: localBeaconUUID)!
        
        if #available(iOS 13.0, *) {
            localBeacon = CLBeaconRegion(uuid: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "LabourAppLocalId")
        
        } else {
            localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Your private identifer here")
        }

        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    //  stops the beacon
    func stopLocalBeacon() {
        peripheralManager?.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }

    //  acts as an intermediary between your app and the iOS Bluetooth stack.
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
            
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
