//
//  ContentView.swift
//  StoreKit2_sample
//
//  Created by eiji.shirakazu on 2024/09/14.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        VStack(spacing: 20) {
            if entitlementManager.hasPro {
                Text("Thank you for purchasing pro!")
            } else {
                Text("Pruducts")
                ForEach(purchaseManager.products, id: \.self) { product in
                    Button {
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Restore Purchase")
                }
            }
        }
        .padding()
        .task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                print(error)
            }
        }
    }
}

/*
 public enum PurchaseResult {
 case success(VerificationResult<Transaction>)
 case userCancelled
 case pending
 }
 
 public enum VerificationResult<SignedType> {
 case unverified(SignedType, VerificationResult<SignedType>.VerificationError)
 case verified(SignedType)
 }
 */

#Preview {
    ContentView()
}
