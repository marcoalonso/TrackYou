//
//  GeofenceActivityAttributes.swift
//  TrackYou
//
//  Created by Marco Alonso on 06/10/24.
//

import Foundation
import ActivityKit

struct GeofenceActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isInGeofence: Bool
        var userLocation: String
    }

    var geofenceName: String
}
