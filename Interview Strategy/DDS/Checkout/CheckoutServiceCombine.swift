//
//  ContentServiceCombine.swift
//  CheckoutInterview
//

import Combine
import Foundation

struct OrderResponse: Codable {
    let id: String
    let items: [OrderItems]
}

struct OrderItems: Codable, Identifiable {
    var id: UUID? = UUID()
    let name: String
    let displayPrice: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "name"
        case displayPrice = "display_price"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.displayPrice = try container.decodeIfPresent(String.self, forKey: .displayPrice) ?? "Free"
    }
}

struct SubmitStatus: Codable {
    let status: String
}

enum SubmitRequestStatus {
    case notsending
    case sending
    case received
}

class CheckoutServiceCombine: ObservableObject {
    @Published var items = [OrderItems]()
    @Published var orderSubmission = SubmitRequestStatus.notsending
    
    private let session = FakeNetworkSession()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.fetchOrder()
    }
    
    func fetchOrder() {
        print("hitted")
        session
            .getOrderPublisher
            .receive(on: DispatchQueue.main)
            .decode(type: OrderResponse.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { completion in
                    print("completion yay!: \(completion)")
                },
                receiveValue: { response in
                    let orderResponse = response as OrderResponse
                    self.items = orderResponse.items
                }
            )
            .store(in: &cancellables)
    }
    
    func submitOrder(orderId: String) {
        self.orderSubmission = .sending
        session
            .submitOrderPublisher
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .decode(type: SubmitStatus.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { status in
                    let submitStatus = status as SubmitStatus
                    if submitStatus.status == "preparing_order" {
                        self.orderSubmission = .received
                    }
                }
            )
            .store(in: &cancellables)
    }
}
