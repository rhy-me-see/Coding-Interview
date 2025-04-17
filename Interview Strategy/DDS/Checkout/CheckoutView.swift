//
//  OrderView.swift
//  CheckoutInterview
//

import SwiftUI

struct CheckoutView: View {
    
    @State private var path = NavigationPath()
    
    private var orderId = UUID().uuidString
    
    @StateObject private var checkoutService = CheckoutServiceCombine()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    ForEach(checkoutService.items) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.displayPrice)
                        }
                    }
                }
                Button(action: {
                    checkoutService.submitOrder(orderId: orderId)
                }) {
                    if checkoutService.orderSubmission == .sending {
                        Text("Submitting...")
                    } else if checkoutService.orderSubmission == .notsending {
                        Text("Submit")
                    } else {
                        Text("Submit")
                    }
                }
                .onChange(of: checkoutService.orderSubmission) { orderSubmission in
                    if orderSubmission == .received {
                        path.append("OrderConfirmationPage")
                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.black)
            }
            .navigationDestination(for: String.self) { pageName in
                if pageName == "OrderConfirmationPage" {
                    OrderConfirmationView()
                }
            }
        }
    }
}

struct OrderConfirmationView: View {
    var body: some View {
        VStack{
            Text("Status: Preparing Order")
        }
    }
}
