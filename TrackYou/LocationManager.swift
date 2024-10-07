//
//  LocationManager.swift
//  TrackYou
//
//  Created by Marco Alonso on 06/10/24.
//
import CoreLocation
import SwiftUI
import ActivityKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    // Solicitar la ubicación actual del usuario
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }

    // Delegate: Cuando se actualizan las ubicaciones del usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        print("Ubicación actual: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation() // Detener la actualización de la ubicación después de obtener la primera
    }

    // Iniciar el monitoreo de una geocerca
    func startMonitoring(geofenceRegionCenter: CLLocationCoordinate2D, radius: Double) {
        let region = CLCircularRegion(center: geofenceRegionCenter, radius: radius, identifier: UUID().uuidString)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        updateGeofenceActivity(isInGeofence: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        updateGeofenceActivity(isInGeofence: false)
    }
    
    func updateGeofenceActivity(isInGeofence: Bool) {
        Task {
            for activity in Activity<GeofenceActivityAttributes>.activities {
                let updatedContentState = GeofenceActivityAttributes.ContentState(isInGeofence: isInGeofence, userLocation: "lat: \(userLocation?.coordinate.latitude), lon: \(userLocation?.coordinate.longitude)")
                
                
                await activity.update(using: updatedContentState)
            }
        }
    }


    // Detener el monitoreo de todas las geocercas
    func stopMonitoring() {
        locationManager.monitoredRegions.forEach { region in
            locationManager.stopMonitoring(for: region)
        }
    }

    // Delegate: Error al obtener la ubicación
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo la ubicación: \(error.localizedDescription)")
    }
}
