//
//  ContentView.swift
//  TrackYou
//
//  Created by Marco Alonso on 06/10/24.
//
import SwiftUI
import MapKit
import ActivityKit

struct GeofenceView: View {
    @StateObject private var locationManager = LocationManager() // Usar @StateObject para que persista
    @State private var selectedRadius: Double = 50.0
    @State private var isGeofenceActive: Bool = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3532, longitude: -122.10760), // Coordenada inicial por defecto
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Zoom del mapa
    )

    let availableRadii = [20.0, 30.0, 50.0, 100.0, 200.0]

    var body: some View {
        VStack(spacing: 20) {
            // Mapa que muestra la ubicación del usuario
            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(height: 300)
                .cornerRadius(10)
                .onAppear {
                    locationManager.requestLocation() // Solicitar la ubicación cuando la vista aparece
                }
                .onChange(of: locationManager.userLocation) { newLocation, oldLocation in
                    if let location = newLocation {
                        region.center = location.coordinate // Actualizar la región cuando la ubicación cambie
                    }
                }

            // Mostrar las coordenadas actuales del usuario
            if let userLocation = locationManager.userLocation {
                Text("Ubicación actual: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
                    .font(.subheadline)
                    .padding(.bottom)
            } else {
                Text("Obteniendo ubicación...")
                    .font(.subheadline)
                    .padding(.bottom)
            }

            // Picker para seleccionar el radio de la geocerca
            Picker("Radio de la geocerca (m)", selection: $selectedRadius) {
                ForEach(availableRadii, id: \.self) { radius in
                    Text("\(Int(radius)) metros").tag(radius)
                }
            }
            .pickerStyle(.automatic)
            .frame(height: 100)

            // Toggle para activar/desactivar la geocerca
            Toggle(isOn: $isGeofenceActive) {
                Text(isGeofenceActive ? "Desactivar Geocerca" : "Activar Geocerca")
            }
            .onChange(of: isGeofenceActive) { oldValue, active in
                if active {
                    if let location = locationManager.userLocation {
                        locationManager.startMonitoring(geofenceRegionCenter: location.coordinate, radius: selectedRadius)
                    }
                    startGeofenceActivity()
                } else {
                    locationManager.stopMonitoring()
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }
    
    func startGeofenceActivity() {
        let initialContentState = GeofenceActivityAttributes.ContentState(
            isInGeofence: true, // Inicialmente, está dentro de la geocerca
            userLocation: "\(String(describing: locationManager.userLocation?.coordinate))")
        

        let activityAttributes = GeofenceActivityAttributes(geofenceName: "Geofence")

        do {
            let _ = try Activity<GeofenceActivityAttributes>.request(
                attributes: activityAttributes,
                contentState: initialContentState,
                pushType: nil // Cambiar si quieres usar notificaciones push
            )
            print("Live Activity iniciada correctamente.")
        } catch (let error) {
            print("Error iniciando Live Activity: \(error.localizedDescription)")
        }
    }
}
