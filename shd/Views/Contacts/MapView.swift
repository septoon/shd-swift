//
//  MapView.swift
//  shd
//
//  Created by Тигран Дарчинян on 12.01.2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var contactsData: ContactsData
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.67661420652112, longitude: 34.4102054908294),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State private var mapError: String?
    @State private var isLoading = true
    @State private var locations: [MapLocation] = []
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Загрузка карты...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("DarkModeBg"))
                    .ignoresSafeArea(edges: .top)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            } else {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .ignoresSafeArea(edges: .top)
            }

            if let error = mapError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        .onAppear {
            if let contact = contactsData.contact {
                let fullAddress = "Россия, Крым, \(contact.address)"
                getCoordinates(for: fullAddress) { coordinate in
                    DispatchQueue.main.async {
                        if let coordinate = coordinate {
                            region.center = coordinate
                            locations = [MapLocation(coordinate: coordinate)]
                            isLoading = false
                        } else {
                            region.center = CLLocationCoordinate2D(latitude: 44.67661420652112, longitude: 34.4102054908294)
                            isLoading = false
                            mapError = "Не удалось определить координаты для адреса."
                        }
                    }
                }
            } else {
                print("Данные еще не загружены")
                isLoading = false
            }
        }
    }

    private func getCoordinates(for address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        print("Геокодируем адрес: \(address)")
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Ошибка геокодирования: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                print("Координаты найдены: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                completion(location.coordinate)
            } else {
                print("Не удалось найти координаты для адреса.")
                completion(nil)
            }
        }
    }
}
