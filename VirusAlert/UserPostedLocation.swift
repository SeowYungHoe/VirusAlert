//
//  UserPostedLocation.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 13/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import Foundation

class UserPosted {
    var longitude: Double?
    var latitude: Double?
    
    
    init(withDictionary dictionary: [String:Any])
    {
        latitude = dictionary["Latitude"] as? Double
        longitude = dictionary["Longitude"] as? Double
    }
}
