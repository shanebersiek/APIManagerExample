//
//  Post.swift
//  APIManagerExample
//
//  Created by Shane Bersiek on 7/29/21.
//

import Foundation

struct Post: Codable {
    var id: Int?
    var title: String?
    var body: String?
    var userId: Int?
}
