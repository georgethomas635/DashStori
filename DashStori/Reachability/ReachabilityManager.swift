//
//  ReachabilityManager.swift
//  BaseProjectStructure
//
//  Created by Amruthaprasad on 25/01/16.
//  Copyright © 2016 Amruthaprasad. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    
    struct Static {
        static var onceToken: Int = 0
        static var instance: ReachabilityManager? = nil
    }
    
    private static var __once: () = {
            Static.instance = ReachabilityManager()
        }()
    
    var reachability : Reachability?

    //MARK: Default Manager
    class var sharedManager: ReachabilityManager {
        
        _ = ReachabilityManager.__once
        return Static.instance!
    }
    
    //MARK: Class Methods
    static func isReachable() -> Bool{
        return ReachabilityManager.sharedManager.reachability!.isReachable
    }
    
    static func isUnreachable() -> Bool {
        return !(ReachabilityManager.sharedManager.reachability!.isReachable)
    }
    
    static func isReachableViaWWAN() -> Bool{
    return ReachabilityManager.sharedManager.reachability!.isReachableViaWWAN
    }
    
    static func isReachableViaWiFi() ->Bool{
    return ReachabilityManager.sharedManager.reachability!.isReachableViaWiFi
    }

    //MARK: Private Initialization
    override init() {
        do {
            // Initialize Reachability
            self.reachability = Reachability.init()
            
            // Start Monitoring
            try self.reachability?.startNotifier()
            
        } catch {
            Utilities.printToConsole(message:"Unable to create Reachability")
            return
        }

    }
}

