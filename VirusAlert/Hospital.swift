//
//  Hospital.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 02/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import Foundation
import SwiftyJSON

class Hospital {
    
    //static var allHospital : [Hospital] = []
    var name : String!
    var longitude : Double?
    var latitude : Double?
    
    init(json: JSON) {
    
        name = json["name"].stringValue
        longitude = json["location"]["lng"].doubleValue
        latitude = json["location"]["lat"].doubleValue
    }
    
}



//static var allBlog : [Blog] = []
//var body : String
//var id: Int
//var title : String
//var updatedAt : String
//var createdAt : String
//
//init(json: JSON) {
//    
//    body = json["body"].stringValue
//    id = json["id"].intValue
//    title = json["title"].stringValue
//    updatedAt = json["updatedAt"].stringValue
//    createdAt = json["createdAt"].stringValue

//}
//
//}
