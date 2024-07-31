//
//  ContentView.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    // Empty array of animals
    @State var animals: [AnimalModel] = []
    
    // Empty search string
    @State var searchText: String = ""
    
    // Returns array of animals based on searchText of all animals if nothing is searched
    var results: [AnimalModel] {
        if searchText.isEmpty {
            return animals
        } else {
            let filter = animals.filter({ $0.id.localizedCaseInsensitiveContains(searchText) })
            return filter
        }
    }
     
    // The view of the app
    var body: some View {
        
        // Setup a sidebar and details view
        NavigationSplitView {
            
            // Show list of animals in sidebar
            List(results) { animal in
                
                // Link to animal details view and pass animal object
                NavigationLink {
                    AnimalDetail(animal: animal)
                } label: {
                    HStack {
                        
                        // Show image from URL
                        AsyncImage(url: URL(string: animal.imageUrl)) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        
                        // Show animal name and living country
                        VStack(alignment: .leading) {
                            Text(animal.id)
                            Text(animal.livingCountry)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                    }
                }
            }
            .searchable(text: $searchText)
            .frame(minWidth: 250)
            .background(.ultraThinMaterial)
        } detail: {
            Text("Select an animal")
        }
        .frame(minWidth: 1000, minHeight: 600)
        // Load animals when view appears
        .task {
            await loadAnimals()
        }
    }
    
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
}

#Preview {
    ContentView()
}
