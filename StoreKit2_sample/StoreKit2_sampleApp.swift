//
//  StoreKit2_sampleApp.swift
//  StoreKit2_sample
//
//  Created by eiji.shirakazu on 2024/09/14.
//

import SwiftUI

@main
struct StoreKit2_sampleApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
