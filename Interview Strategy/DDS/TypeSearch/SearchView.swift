//
//  DoordashDebugDemo.swift
//  Created for interview prep
//

import SwiftUI
import Combine

// MARK: - View

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel(mockSearchService: MockSearchService())

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search menu items...", text: $viewModel.query)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                if viewModel.showingHistory {
                    HStack {
                        Text("Recent Search")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button("Clear Result") {
                            viewModel.clearHistory()
                        }
                        .padding()
                        .border(.yellow)
                    }
                }
                List {
                    ForEach(viewModel.showingHistory ? viewModel.recentHistory: viewModel.searchResult, id: \.self) { result in
                        Text(result)
                            .onTapGesture {
                                viewModel.selectResult(result)
                            }
                    }

                }
                .listStyle(.plain)
            }
            .navigationTitle("Typeahead Search")
        }
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
