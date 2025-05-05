import UIKit
import Flutter
import CoreBluetooth // Required for Bluetooth connectivity

@main
@objc class AppDelegate: FlutterAppDelegate , CBCentralManagerDelegate, CBPeripheralDelegate {
    
    lazy var centralManager: CBCentralManager = {
        let manager = CBCentralManager(delegate: self, queue: nil)
        return manager
    }()
    var printerPeripheral: CBPeripheral?
    var receiptData: Data?
    var result: FlutterResult?  // Store result to send success or failure later
    var hasPrinted = false  // Track if printing has already started
    
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let printerChannel = FlutterMethodChannel(name: "bluetooth_printer", binaryMessenger: controller.binaryMessenger)
        
        printerChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "printReceipt" {
                if let args = call.arguments as? [String: Any],
                   let dataString = args["data"] as? String {
                    self.receiptData = dataString.data(using: .utf8)
                    self.startBluetoothPrinting(result: result)
                    //self.hasPrinted = true  // Set flag to true after starting the print
                } else {
                    result(FlutterError(code: "ERROR", message: "Invalid data", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
            
            if call.method == "printImage" {
                if let args = call.arguments as? [String: Any],
                   let data = args["data"] as? FlutterStandardTypedData {
                    let imageData = data.data // Image data received from Flutter
                    // Here, send imageData to the printer
                    self.sendImageToPrinter(imageData: imageData)
                } else {
                    result(FlutterError(code: "ERROR", message: "Invalid data", details: nil))
                }
            }
      }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Method to send image data to the printer
    func sendImageToPrinter(imageData: Data) {
        guard let printerPeripheral = self.printerPeripheral else {
            print("Printer not connected")
            return
        }
        
        // Convert the image data to the correct format for your printer
        // You may need to implement a specific encoding method based on your printer's requirements
        let printCommand = createPrintCommand(from: imageData)
        printerPeripheral.discoverServices(nil) // Discover all services
        if let characteristic = findCharacteristic(for: printerPeripheral) {
            printerPeripheral.writeValue(printCommand, for: characteristic, type: .withResponse)
            print("Sent image data to printer")
        }
    }



    func findCharacteristic(for peripheral: CBPeripheral) -> CBCharacteristic? {
        // Check if peripheral has services
        for service in peripheral.services ?? [] {
            // Check if the service has characteristics
            for characteristic in service.characteristics ?? [] {
                // Return the first characteristic found (or modify this to return a specific one)
                return characteristic
            }
        }
        return nil // Return nil if no characteristics found
    }

    // Create print command based on image data (you need to implement this based on your printer's specs)
    func createPrintCommand(from imageData: Data) -> Data {
        // Placeholder - Add necessary commands for your specific printer
        return imageData
    }
    
    // Initialize Bluetooth Manager and start scanning for devices
    func startBluetoothPrinting(result: @escaping FlutterResult) {
        // Initialize the central manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        self.result = result  // Store result to return it later when printing is done
        centralManager.scanForPeripherals(withServices: nil) // Start scanning for printers
    }

    // Delegate method to check Bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn
            //&& !isConnecting
        {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                // Bluetooth is ready to scan for peripherals
               // if self?.isConnecting ?? false {
                   // self?.isConnecting = true
                    self.centralManager.scanForPeripherals(withServices: nil)
            print("Bluetooth is powered on.")
              //  }
            //}
        } else {
            // Handle other states (e.g., .resetting, .unsupported) if needed
            print("Bluetooth state is not ready or powered off. Current state: \(central.state.rawValue)")
        }
    }
      
      // Discovered a peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.contains("MTP-III") == true 
            //&& !isConnecting
        {  // Replace with actual printer name
            //isConnecting = true
            printerPeripheral = peripheral
            centralManager.stopScan() // Stop scanning to prevent multiple connections
            centralManager.connect(peripheral, options: nil)
            print("Connecting to \(peripheral.name ?? "printer")...")
        }
    }
      
      // Connected to the peripheral
      func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "printer")")
        //printerPeripheral = peripheral
        printerPeripheral?.delegate = self
        printerPeripheral?.discoverServices(nil)
      }
      
      // Discovered services on the peripheral
      func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
          peripheral.discoverCharacteristics(nil, for: service)
        }
      }
      
      // Discovered characteristics on the peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) {
                if let data = receiptData {
                    if !hasPrinted {  // Check if printing is already in progress
                        let setEncoding = "\u{1B}\u{28}\u{6A}\u{00}\u{01}\u{00}" // Command to switch to UTF-8
                        if let encodingData = setEncoding.data(using: .utf8) {
                            peripheral.writeValue(encodingData, for: characteristic, type: .withResponse)
                            
                            self.hasPrinted = true  // Set flag to true after starting the print
                            //print("Sent data to printer")
                        }
                        if let data = receiptData {
                            let utf8Data = data // Ensure this data is in the correct format
                            peripheral.writeValue(utf8Data, for: characteristic, type: .withResponse)
                            self.hasPrinted = true  // Set flag to true after starting the print
                            print("Sent data to printer")
                            //return // Exit the loop after sending data once
                        }
                    }
                }
                return  // Exit after handling the write operation
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error = error {
                    print("Error writing value to characteristic: \(error.localizedDescription)")
                    result?(FlutterError(code: "PRINT_ERROR", message: error.localizedDescription, details: nil))
                } else {
                    print("Data sent to printer successfully.")
                    hasPrinted = false // Reset the flag for future prints
                    result?(nil) // Indicate success
                    
                }
    }
      
      // Handle potential errors or disconnections
      func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
          print("Failed to connect to printer: \(error?.localizedDescription ?? "unknown error")")
                  result?(FlutterError(code: "CONNECTION_ERROR", message: error?.localizedDescription, details: nil))
      }
      
      func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from printer")
          hasPrinted = false  // Allow printing again in the next session
          //isConnecting = false
      }
    
//    func printReceipt(data: String) {
//        if !hasPrinted {
//            hasPrinted = true
//            self.receiptData = data.data(using: .utf8)
//            startBluetoothPrinting(result: resu)
//        }
//    }

}
