//
//  ParseJsonWithCombine.swift
//  PracticeDDS
//
//  Created by Ruohua Yin on 2/23/25.
//
import SwiftUI
import Combine

struct PostModel: Identifiable, Codable {
    let id: UUID = UUID()
    let title: String?
    let image: String?
    let information: String
    let count: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.information = try container.decode(String.self, forKey: .information)
        self.count = 0
    }
}

struct FileModel: Codable {
    let name: String
    let content: [PostModel]
}

class DownloadWithCombineViewModel: ObservableObject {
    
    @Published var posts = [PostModel]()
    @Published var countMap = [UUID: Int]()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        print("get post")
        
        guard let url = Bundle.main.url(forResource: "Datasource", withExtension: "json") else {
                print("Failed to find Datasource.json")
                return
        }
//        guard let url = URL(string: "https://my-json-server.typicode.com/typicode/demo/posts") else { return }
        
        print("path valid")
        //https://www.youtube.com/watch?v=fdxFp5vU6MQ
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap( { (data, response) -> Data in
//                guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200 else {
//                    throw URLError(.badServerResponse)
//                }
                print("response: \(response)")
                print("data: \(data)")
                return data
            })
            .decode(type: FileModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion: \(completion)")
            } receiveValue: { (returnedFileModel) in
                let fm = returnedFileModel as FileModel
                self.posts = fm.content
                for post in self.posts {
                    self.countMap[post.id] = 0
                }
                print("self.posts: \(self.posts)")
                print("self.countMap: \(self.countMap)")
            }
            .store(in: &cancellables)
    }
    
}
