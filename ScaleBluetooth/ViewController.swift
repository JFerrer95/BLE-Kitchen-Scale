//
//  ViewController.swift
//  ScaleBluetooth
//
//  Created by Jonathan Ferrer on 12/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var scale: CBPeripheral?
    
    let serviceUUID = CBUUID(string: "FFF0")
    let serviceUUID2 = CBUUID(string: "FEE7")
    let serviceUUID3 = CBUUID(string: "D618D000-6000-1000-8000-000000000000")
    let kitchenScaleCharacteristicUUID = CBUUID(string: "FFF1")
    let kitchenScaleCharacteristicUUID2 = CBUUID(string: "FFF2")
    let kitchenScaleCharacteristicUUID3 = CBUUID(string: "FEC7")
    let kitchenScaleCharacteristicUUID4 = CBUUID(string: "FEC8")
    let kitchenScaleCharacteristicUUID5 = CBUUID(string: "FEC9")
    let kitchenScaleCharacteristicUUID6 = CBUUID(string: "D618D010-6000-1000-8000-000000000000")
    let kitchenScaleCharacteristicUUID7 = CBUUID(string: "D618D020-6000-1000-8000-000000000000")
    let kitchenScaleCharacteristicUUID8 = CBUUID(string: "D618D030-6000-1000-8000-000000000000")
    
    
    @IBOutlet weak var weightLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        centralManager = CBCentralManager()
        centralManager.delegate = self
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        centralManager.stopScan()
//        scale = peripheral
//        centralManager.connect(peripheral, options: nil)
        
        if let name = peripheral.name {
            print(name)
        }
        
        if peripheral.name == "smartchef" {
            centralManager.stopScan()
            scale = peripheral
            centralManager.connect(peripheral, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connectedddd to: \(peripheral.name!)")
        peripheral.delegate = self
        peripheral.discoverServices([])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
        }
        
        if let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }) {
            peripheral.discoverCharacteristics([], for: service)
        }
        
        
        
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for charact in characteristics {
            print(charact)
        }
        
        if let characteristics = service.characteristics?.first(where: { $0.uuid == kitchenScaleCharacteristicUUID}) {
            peripheral.setNotifyValue(true, for: characteristics)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            let weight: Int = data.withUnsafeBytes{ $0.pointee } //>> 34 & 0xFFFFFF
            weightLabel.text = String(weight)
        }

    }

}
