//
//  APIService.swift
//  KVOTest
//
//  Created by Rehnuma Reza on 17/2/23.
//

import Foundation
import UIKit

final class APIService {
    static let productsBaseURL = URL(string: "https://dummyjson.com/products")
    static var productsThumbnailImageURLDictionary = [Int : String]()
    
    // MARK: Products
    static func getProducts(url: URL?) async throws -> [ProductModel] {
        guard let url = url else { return [] }
        
        do {
            let (data, _) =  try await URLSession.shared.data(from: url)
            
            let parsedData = try JSONDecoder().decode(ProductList.self,
                                                      from: data)
            
            let _ =  parsedData.products.map {
                productsThumbnailImageURLDictionary[$0.id] = $0.thumbnail
            }
            
            return parsedData.products
            
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    static func getImages(urlStrings: [String]) async throws -> [String : UIImage] {
        var thumbnails: [String: UIImage] = [ : ]
        
        //1. ForEach
//        urlStrings.forEach { urlString in
//            guard let url = URL(string: urlString) else { }
//
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            let image = UIImage(data: data)
//
//            thumbnails[urlString] = image
//        }
        
        //2. For loop
        for urlString in urlStrings {
            guard let url = URL(string: urlString) else { return [ : ] }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let image = UIImage(data: data)
            
            thumbnails[urlString] = image
            
        }
        
        return thumbnails
        
    }

}
