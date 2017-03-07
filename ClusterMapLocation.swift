//
//  ClusterMapLocation.swift
//  ClusterMap
//
//  Created by Aaron Dean Bikis on 3/6/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation

/**
 Conform your data structure to this in order to pass an instance of your data to the *QuadTreeCoordinator*
*/
public protocol ClusterMapLocation {
    var latitude: Double { get set }
    var longitude: Double { get set }
    var id: Int { get set }
}
