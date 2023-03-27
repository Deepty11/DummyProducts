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
    static let usersBaseURL = URL(string: "https://dummyjson.com/users")
    
    static var productsThumbnailImageURLDictionary = [Int : String]()
    static var usersThumbnailImageURLDictionary = [Int : String]()
    
    static func getData <T: Decodable>(url: URL?, dataType: T.Type) async throws -> T? {
        guard let url = url else { return nil }
        do {
            print("Started \(dataType)")
            let (data, _) =  try await URLSession.shared.data(from: url)
            
            let parsedData = try JSONDecoder().decode(T.self, from: data)
            
            return parsedData
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func getImages(from urlStrings: [String]) async throws -> [String : UIImage] {
        var thumbnails: [String: UIImage] = [ : ]
        
        for urlString in urlStrings {
            
            let _ = await withTaskGroup(of: (String, UIImage).self,
                                        returning: [String: UIImage].self,
                                        body: { groupTask in
                groupTask.addTask {
                    do {
                        let image = try await getImage(from: urlString)
                        
                        return (urlString, image)
                    } catch { print(error.localizedDescription) }
                    
                    return (urlString, UIImage())
                }
                
                return await groupTask.reduce(into: [String: UIImage]()) { partialResult, result in
                    thumbnails[result.0] = result.1
                }
            })
        }
        
        return thumbnails
        
    }
    
    
    static func getImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { return UIImage()}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return  UIImage(data: data) ?? UIImage()
        
    }

}
