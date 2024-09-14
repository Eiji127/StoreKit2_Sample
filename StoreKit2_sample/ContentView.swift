//
//  ContentView.swift
//  StoreKit2_sample
//
//  Created by eiji.shirakazu on 2024/09/14.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]
    @State private var products: [Product] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Pruducts")
            ForEach(products, id: \.self) { product in
                Button {
                    
                } label: {
                    Text("\(product.displayPrice) - \(product.displayName)")
                }
            }
        }
        .padding()
        .task {
            do {
                try await loadProducts()
            } catch {
                print(error)
            }
        }
    }
    
    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
}

#Preview {
    ContentView()
}
