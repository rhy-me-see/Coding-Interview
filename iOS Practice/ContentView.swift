//
//  ContentView.swift
//  PracticeDDS
//
//  Created by Ruohua Yin on 2/23/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = DownloadWithCombineViewModel()
    
    @State private var count = 0
    
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    ForEach(vm.posts) { post in
                        HStack {
                            Image("\(post.image ?? "taco")")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .border(.blue)
                            VStack(alignment: .leading) {
                                Text(post.title ?? "Unknown").font(.headline)
                                Text(post.information).font(.subheadline)
                                Text("$20.20").font(.footnote)
                            }
                            Stepper("\(count)", value: $count, in: 1...10)
                        }
                    }
                }
                .border(.red)
                
                Button("Submit Order") {
                    path.append("OrderStatus")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Order")
            .navigationDestination(for: String.self) { value in
                if value == "OrderStatus" {
                    OrderStatusView(orderCount: vm.posts.count)
                }
            }
        }
    }
}

struct OrderStatusView: View {
    let orderCount: Int
    var body: some View {
        VStack {
            Text("Your Order of \(orderCount) items has been submitted")
        }
        .navigationTitle("Order Status")
    }
}

#Preview {
    ContentView()
//    OrderStatusView(orderCount: 1)
}
