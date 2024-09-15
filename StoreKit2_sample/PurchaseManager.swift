//
//  PurchaseManager.swift
//  StoreKit2_sample
//
//  Created by eiji.shirakazu on 2024/09/15.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]
    
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    /// 
    @Published private(set) var products: [Product] = []
    
    /// 製品の購入取得フラグ
    private var productsLoaded = false
    
    /// 購入製品の有無
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    /// 製品情報の取得処理
    func loadProducts() async throws {
        guard !productsLoaded else {
            return
        }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    /// 製品の購入処理
    ///
    /// - Parameter product: 購入対象製品
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(.verified(let transaction)):
            await transaction.finish()
            await updatePurchasedProducts()
        case .success(.unverified(_, let error)):
            break
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    /// 有料の機能やコンテンツを解放するための有効であることが確認できた製品IDの更新処理
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    /// アプリの外部で作成されたトランザクションの監視処理
    /// サブスクリプションの更新や解約、または課金の問題によって取り消されたサブスクリプションなどの監視を行う。
    ///
    /// - Returns: 非同期処理の結果
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
