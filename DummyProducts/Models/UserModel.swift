//
//  UserModel.swift
//  DummyProducts
//
//  Created by Rehnuma Reza on 10/3/23.
//

import Foundation

struct UserModel: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var age: Int
    var gender: String
    var image: String
    
    var fullName: String { "\(firstName) \(lastName)" }
}

struct UserList: Decodable {
    var users: [UserModel]
}
