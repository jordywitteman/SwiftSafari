//
//  AnimalDetail.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import SwiftUI
import MapKit

struct AnimalDetail: View {
    
    var animal: AnimalModel
    
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
    
    @State var location = CLLocationCoordinate2D()
    
    @State var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
            )
    )
    
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
                
                VStack {
                    Image(systemName: dietSymbol)
                        .resizable()
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 60, height: 60)
                }
                
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
                
                Text(animal.description)
            }
            
            Map(position: $position) {
                Marker(animal.livingCountry, coordinate: location)
            }
            .onMapCameraChange(frequency: .continuous) { context in
                    print(context.region)
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
        .task {
            getCoordinate(addressString: animal.livingCountry) { coordinates, error in
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
                    )
                )
                location = coordinates
            }
        }
    }
    
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
