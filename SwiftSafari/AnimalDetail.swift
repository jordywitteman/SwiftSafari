//
//  AnimalDetail.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import SwiftUI
import MapKit

struct AnimalDetail: View {
    
    // View requires an animal object
    var animal: AnimalModel
    
    // Return SF Symbol string based on animal diet
    var dietSymbol: String {
        switch animal.diet {
        case "meat":
            return "fork.knife.circle.fill"
        case "fish":
            return "fish.circle.fill"
        case "vegetables":
            return "leaf.circle.fill"
        default:
            return ""
        }
    }
    
    // Return SF Symbol string based on threatening status
    var threatenedSymbol: String {
        if animal.threatened {
            return "exclamationmark.triangle.fill"
        } else {
            return "checkmark.seal.fill"
        }
    }
    
    // Return color based on threatening status
    var threatenedColor: Color {
        if animal.threatened {
            return .red
        } else {
            return .green
        }
    }
    
    // Variable with a location to show in the map
    @State var location = CLLocationCoordinate2D()
    
    // Variable with position shown on the map
    @State var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
            )
    )
    
    // The view
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(animal.id)
                        .font(.largeTitle)
                    Text(animal.livingCountry)
                        .foregroundStyle(.secondary)
                        .font(.title2)
                    
                }
                
                Spacer()
                
            }
            
            Divider()
                .padding(.vertical)
            
            HStack(alignment: .top) {
                
                AsyncImage(url: URL(string: animal.imageUrl)) { image in
                    image.resizable()
                        .scaledToFill()
                        .clipShape(.circle)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 250)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("About \(animal.id)")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text(animal.description)
                    
                    Spacer()
                    
                }
                .padding()
                
                Spacer()
                
                Divider()
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Threatened")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: threatenedSymbol)
                        .resizable()
                        .foregroundStyle(threatenedColor)
                        .frame(width: 60, height: 60)
                        .animation(.default, value: threatenedColor)
                        .contentTransition(.symbolEffect(.replace))
                    
                    Text("Diet")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Image(systemName: dietSymbol)
                        .resizable()
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 60, height: 60)
                        .contentTransition(.symbolEffect(.replace))
                }
                .padding()
            }
            
            // Show map
            Map(position: $position) {
                Marker(animal.livingCountry, coordinate: location)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top)
            
            Spacer()
            
        }
        .padding()
        .onChange(of: animal.livingCountry) {
            getCoordinate(addressString: animal.livingCountry) { coordinates, error in
                withAnimation {
                    position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: coordinates,
                            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
                        )
                    )
                }
                location = coordinates
            }
        }
        // Get coordinates based on animal's living country when view appears
        .task {
            getCoordinate(addressString: animal.livingCountry) { coordinates, error in
                // Set center position of map to returned coordinates
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
                    )
                )
                // Set location to use as marker on the map
                location = coordinates
            }
        }
    }
    
    // MARK: - Function to return coordinates based on a location name
    // https://developer.apple.com/documentation/corelocation/converting-between-coordinates-and-user-friendly-place-names
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
