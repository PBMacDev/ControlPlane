//
//  WiFiEvidenceSource.swift
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 7/3/19.
//

import Foundation
import CoreWLAN


@objc(WiFiEvidenceSourceCoreWLAN) class WiFiEvidenceSource: GenericEvidenceSource, CWEventDelegate {
    var networkSSIDs: [String: String]
    var connectedToSecureNetwork: Bool = true
    var defaultInterfaceName: String = ""
    
    override init() {
        networkSSIDs = Dictionary.init()
        super.init()
        CWWiFiClient.shared().delegate = self
    }
    override func description() -> String! {
        return "Create rules based on what WiFi networks are available or connected to."
    }
    override func name() -> String! {
        return "WiFi"
    }
    override func friendlyName() -> String! {
        return "Nearby WiFi Network."
    }
    override func typesOfRulesMatched() -> [Any]! {
        return ["WiFi BSSID", "WiFi SSID", "WiFi Security"]
    }
    override func doesRuleMatch(_ rule: NSMutableDictionary!) -> Bool {
        if rule != nil {
            let param: String = (rule["parameter"] as! String)
            let ruleType: String = (rule["type"] as! String)
            if (ruleType == "WiFi BSSID") {
                    return self.networkSSIDs.values.contains(param)
            } else
            if (ruleType == "WiFi SSID") {
                return self.networkSSIDs.keys.contains(param)
            } else
            if (ruleType == "WiFi Security") {
                if param == "Secure" {
                    return self.connectedToSecureNetwork
                } else {
                    return !self.connectedToSecureNetwork
                }
            }
        }
        return false
    }
    override func start() {
        if !self.isRunning {
            self.isRunning = true
            
            self.recollectNetworkData()
            try? CWWiFiClient.shared().startMonitoringEvent(with: CWEventType.scanCacheUpdated)
            try? CWWiFiClient.shared().startMonitoringEvent(with: CWEventType.linkDidChange)
        }
    }
    override func stop() {
        try? CWWiFiClient.shared().stopMonitoringAllEvents()
        self.connectedToSecureNetwork = true
        self.networkSSIDs.removeAll()
        self.isRunning = false
    }
    func updateNetworkData(fromScanResults networks: Set<CWNetwork>) {
        networkSSIDs.removeAll()
        for network in networks {
            let ssid = network.ssid
            let bssid = network.bssid
            if ssid != nil, bssid != nil {
                networkSSIDs[ssid!] = bssid!
            }
        }
    }
    func recollectNetworkData() {
        let currentInterface = CWWiFiClient.shared().interface()
        if currentInterface != nil {
            let foundNetworks = currentInterface?.cachedScanResults()
            
            if foundNetworks != nil {
                self.updateNetworkData(fromScanResults: foundNetworks!)
            }
            
            self.defaultInterfaceName = currentInterface?.interfaceName ?? ""
            
            if currentInterface?.security() == CWSecurity.none {
                self.connectedToSecureNetwork = false
            }
        }
    }
    
    // CWWiFiClient delegate protocol
    
    // Tells the delegate that the Wi-Fi interface's scan cache has been updated with new results.
    func scanCacheUpdatedForWiFiInterface(withName interfaceName: String) {
        if self.defaultInterfaceName == interfaceName {
            let cashedScanResults = CWWiFiClient.shared().interface(withName: interfaceName)?.cachedScanResults()
            if cashedScanResults != nil {
                self.updateNetworkData(fromScanResults: cashedScanResults!)
            }
        }
    }
    // Tells the delegate that the connection to the Wi-Fi subsystem is permanently invalidated.
    func clientConnectionInvalidated()
    {
        //TODO: to research if this call back is needed at all
//        self.recollectNetworkData()
    }
    // Tells the delegate that the connection to the Wi-Fi subsystem is temporarily interrupted.
    func clientConnectionInterrupted()
    {
        //TODO: to research if this call back is needed at all
//        self.recollectNetworkData()
    }
    // Tells the delegate that the Wi-Fi link state changed.
    func linkDidChangeForWiFiInterface(withName interfaceName: String)
    {
        if self.defaultInterfaceName == interfaceName {
            let currentInterface = CWWiFiClient.shared().interface()
            if currentInterface != nil, currentInterface?.security() == CWSecurity.none {
                self.connectedToSecureNetwork = false
            } else {
                self.connectedToSecureNetwork = true
            }
        }
    }

    // UI support
    override func getSuggestionLeadText(_ type: String!) -> String! {
        if type == "WiFi BSSID" {
            return "A WiFi access point with a BSSID of"
        } else
        if type == "WiFi Security" {
                return "Current WiFi network is:"
        }

        return "A WiFi access point with an SSID of"
    }
    override func getSuggestions() -> [Any]! {
        let sortedSSIDs = self.networkSSIDs.keys.sorted()
        let suggestions: NSMutableArray = NSMutableArray.init(capacity: networkSSIDs.count*2 + 2)
        for ssid in sortedSSIDs {
            let bssid: String = self.networkSSIDs[ssid]!
            suggestions.add(["type": "WiFi BSSID", "parameter": bssid, "description": "\(bssid) (\(ssid))"])
            suggestions.add(["type": "WiFi SSID", "parameter": ssid, "description": ssid])
        }
        suggestions.add(["type": "WiFi Security", "parameter": "Secure", "description": "Secure"])
        suggestions.add(["type": "WiFi Security", "parameter": "Not Secure", "description": "Not Secure"])

        return suggestions as? [Any]
    }

}
