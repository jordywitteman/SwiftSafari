//
//  ContentView.swift
//  SwiftSafari
//
//  Created by Jordy Witteman on 22/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var animals: [AnimalModel] = []
    
    @State var searchText: String = ""
    
    var results: [AnimalModel] {
        if searchText.isEmpty {
            return animals
        } else {
            let filter = animals.filter( { $0.id.localizedCaseInsensitiveContains(searchText) })
            return filter
        }
    }
        
    var body: some View {
        
        NavigationSplitView {
            List(results) { animal in
                NavigationLink {
                    AnimalDetail(animal: animal)
                } label: {
                    HStack {
                        
                        AsyncImage(url: URL(string: animal.imageUrl)) { image in
                            image.resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        
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
        .navigationTitle("Animals")
        .frame(minWidth: 800, minHeight: 400)
        .task {
            await loadAnimals()
        }
    }
    
    func loadAnimals() async {
        
        guard let url = Bundle.main.url(forResource: "animals", withExtension: "json") else {
            return
        }
        
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
