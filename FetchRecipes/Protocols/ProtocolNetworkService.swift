//
//  NetworkService.swift
//  FetchRecipes
//
//  Created by Fredy on 12/10/24.
//


import Foundation

// NetworkService protocol
protocol NetworkService {
    func fetchData(from url: URL) async throws -> Data
}

