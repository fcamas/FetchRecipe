//
//  ExtensionURLSeccion.swift
//  FetchRecipes
//
//  Created by Fredy on 12/10/24.
//

import Foundation

// URLSessionNetworkService is a concrete class that implements NetworkService
class URLSessionNetworkService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
