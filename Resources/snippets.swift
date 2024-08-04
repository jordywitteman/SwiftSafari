
//////////////////////////////// SNIPPET 1 /////////////////////////////////////

struct AnimalModel: Identifiable, Codable {
    
    let id: String
    let livingCountry: String
    let imageUrl: String
    let description: String
    let diet: String
    let threatened: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "type"
        case livingCountry = "living_country"
        case imageUrl = "image_url"
        case description = "description"
        case diet = "diet"
        case threatened = "threatened_status"
    }
    
}

//////////////////////////////// SNIPPET 2 /////////////////////////////////////

// MARK: - Load animals.json from app bundle, decode it and store it into animals variable to show in the view
func loadAnimals() async {
    
    // Try to locate animals.json
    guard let url = Bundle.main.url(forResource: "animals", withExtension: "json") else {
        return
    }
    
    // Decode and store animals into animals @State variable
    do {
        let animalData = try Data(contentsOf: url)
        animals = try JSONDecoder().decode([AnimalModel].self, from: animalData)
    } catch {
        print("Failed to get animals")
    }
}

//////////////////////////////// SNIPPET 3 /////////////////////////////////////

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

//////////////////////////////// SNIPPET 4 /////////////////////////////////////

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