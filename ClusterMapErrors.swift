//
//  ClusterMapErrors.swift
//  ClusterMap
//
//  Created by Aaron Dean Bikis on 3/6/17.
//  Copyright © 2017 7apps. All rights reserved.
//

import Foundation

public enum ClusterMapErrors: Error {
    case quadTreeCoordinatorNotIntaciated
    
    var description: String {
        switch self {
        case .quadTreeCoordinatorNotIntaciated:
            return "An instance of Quad Tree coordinator must be instanciated and set as a variable on the viewController attempting to build a quad tree."
        }
    }
}
