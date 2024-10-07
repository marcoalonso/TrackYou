//
//  GeofenceWidgetBundle.swift
//  GeofenceWidget
//
//  Created by Marco Alonso on 06/10/24.
//

import WidgetKit
import SwiftUI

struct GeofenceWidgetBundle: WidgetBundle {
    var body: some Widget {
        GeofenceWidget()
        GeofenceWidgetLiveActivity()
    }
}
