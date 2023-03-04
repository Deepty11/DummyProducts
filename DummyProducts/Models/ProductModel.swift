//
//  ProductModel.swift
//  KVOTest
//
//  Created by Rehnuma Reza on 2/3/23.
//

import Foundation

struct ProductModel: Decodable {
    var id: Int
    var title: String
    var description: String
    var price: Int
    var thumbnail: String
}

struct ProductList: Decodable {
    var products: [ProductModel]
}
