//
//  APIService.swift
//  KVOTest
//
//  Created by Rehnuma Reza on 17/2/23.
//

import Foundation

final class APIService {
    static let baseURL = URL(string: "https://api.instantwebtools.net/v1/airlines")
    static let productsBaseURL = URL(string: "https://dummyjson.com/products")
    
    
    // MARK: Products
    static func getProducts(url: URL?) async throws -> [ProductModel] {
        guard let url = url else { return [] }
        
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            
            let parsedData = try JSONDecoder().decode(ProductList.self,
                                                      from: data)
            
            return parsedData.products
            
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }

}
