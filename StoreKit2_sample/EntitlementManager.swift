//
//  EntitlementManager.swift
//  StoreKit2_sample
//
//  Created by eiji.shirakazu on 2024/09/15.
//

import Foundation
import SwiftUI

class EntitlementManager: ObservableObject {
    /// 
    static let userDefaults = UserDefaults(suiteName: "com.cychow-app.StoreKit2-sample")!
    
    @AppStorage("hasPro", store: userDefaults) var hasPro: Bool = false
}
