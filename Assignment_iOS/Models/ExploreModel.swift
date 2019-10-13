//
//  ExploreModel.swift
//  Assignment_iOS
//
//  Created by Mohammad Dijoo on 12/10/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation

struct ExploreModel : Codable {
    var title : String
    var nodes : [VideoModel]
}

struct VideoModel : Codable {
    var video : VideoURL
}

struct VideoURL : Codable {
    var encodeUrl : String
}
