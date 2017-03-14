//
//  CustomPointAnnotation.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 06/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import MapKit

enum CustomAnotationType {
    case hospital
    case dengue
    case userPosted
}

class CustomPointAnnotation: MKPointAnnotation{
    
    var anotationType : CustomAnotationType = .dengue
    var image: String!

}
