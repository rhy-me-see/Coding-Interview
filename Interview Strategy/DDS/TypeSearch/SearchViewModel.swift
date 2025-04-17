
import Combine
import Foundation

// MARK: - ViewModel

class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var searchResult = [String]()
    @Published var recentHistory = [String]()
    @Published var showingHistory: Bool = true

    private var searchService: SearchServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(mockSearchService: SearchServiceProtocol) {
        self.searchService = mockSearchService
        bindSearch()
    }
    
    func bindSearch() {
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] newQuery in
                guard let self = self else { return }
                if newQuery.isEmpty {
                    self.showingHistory = true
                } else {
                    self.showingHistory = false
                    // TODO: check local cache, update searchResult, return(avoid network request)
                    // if result not found:--> trigger the search from network request
                    self.searchService.search(query: newQuery)
                        .sink { [weak self] values in
                            self?.searchResult = values
                        }
                        .store(in: &cancellables)
                }
            }
            .store(in: &cancellables)
    }
    
    func selectResult(_ text: String) {
        addToHistory(text)
        query = text
        showingHistory = false
    }
    
    private func addToHistory(_ text: String) {
        recentHistory.removeAll(where: { $0.caseInsensitiveCompare(text) == .orderedSame })
        recentHistory.insert(text, at: 0)
        if recentHistory.count > 5 {
            recentHistory.removeLast()
        }
    }
    
    func clearHistory() {
        recentHistory.removeAll()
    }
}
