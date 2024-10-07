//
//  GeofenceWidget.swift
//  GeofenceWidget
//
//  Created by Marco Alonso on 06/10/24.
//

import WidgetKit
import SwiftUI
import ActivityKit

@main
struct GeofenceWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GeofenceActivityAttributes.self) { context in
            GeofenceActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    GeofenceActivityView(context: context)
                }
            } compactLeading: {
                Text("GEO")
            } compactTrailing: {
                Text(context.state.isInGeofence ? "In" : "Out")
            } minimal: {
                Text(context.state.isInGeofence ? "In" : "Out")
            }
        }
    }
}

struct GeofenceActivityView: View {
    let context: ActivityViewContext<GeofenceActivityAttributes>

    var body: some View {
        VStack {
            if context.state.isInGeofence {
                Text("Dentro de la geocerca")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("Fuera de la geocerca")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            Text("Ubicación: \(context.state.userLocation)")
                .font(.subheadline)
        }
    }
}

