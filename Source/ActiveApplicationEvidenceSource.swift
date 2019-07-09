//
//  ActiveApplicationEvidenceSource.swift
//  ControlPlaneX
//
//  Created by Pavlo Boyko on 7/1/19.
//

import Foundation

class ActiveApplicationRule: Rule {
    override class var name: String {return "ActiveApplication"}
}

@objc(ActiveApplicationEvidenceSource) class ActiveApplicationEvidenceSource: GenericEvidenceSource {
    private static var myContext = 0
    var activeApplication: String
    
    override init() {
        self.activeApplication = ""
        super.init()
    }
    override func description() -> String! {
        return "Allows you to define rules based on the active or foreground application."
    }
    override func name() -> String! {
        return "ActiveApplication"
    }
    override func friendlyName() -> String! {
        return "Active Application."
    }
    override func doesRuleMatch(_ rule: NSMutableDictionary!) -> Bool {
        if rule != nil {
            let param: String? = (rule["parameter"] as! String)
            if param != nil {
                return param?.isEqual(self.activeApplication) ?? false
            }
        }
        return false
    }
    override func start() {
        if !self.isRunning {
            self.isRunning = true
        
            NSWorkspace.shared.addObserver(self, forKeyPath: "frontmostApplication", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: &ActiveApplicationEvidenceSource.myContext)
        }
    }
    override func stop() {
        NSWorkspace.shared.removeObserver(self, forKeyPath: "frontmostApplication")
        self.isRunning = false
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ActiveApplicationEvidenceSource.myContext {
            self.activeApplication = NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? ""
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // UI support
    override func getSuggestionLeadText(_ type: String!) -> String! {
        return "The following application is active"
    }
    override func getSuggestions() -> [Any]! {
        let runningApps = NSWorkspace.shared.runningApplications
        let suggestions: NSMutableArray = NSMutableArray.init(capacity: runningApps.count)
        for obj in runningApps {
            let identifier = obj.bundleIdentifier
            let name = obj.localizedName
            if identifier != nil, name != nil {
                let objs = NSArray.init(objects: "ActiveApplication", identifier ?? ".", name ?? "noname")
                let keys = NSArray.init(objects: "type", "parameter", "description")
                //TODO: implement original functionality as in following objc code
                //            if ((identifier != nil) && ([identifier length] > 0) && (name != nil)) {
                //            [suggestions addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ActiveApplication", @"type", identifier, @"parameter", [NSString stringWithFormat:@"%@ (%@)", name, identifier], @"description", nil]];
                //            }
                suggestions.add(NSDictionary.init(objects: objs as! [Any], forKeys: keys as! [NSCopying]))
            }
        }
        
        return suggestions as? [Any]
    }
    deinit {
        self.stop()
    }
}

