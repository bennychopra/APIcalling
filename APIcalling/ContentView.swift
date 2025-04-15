//
//  ContentView.swift
//  APIcalling
//
//  Created by Benny Chopra on 4/15/25.
//

import SwiftUI

// MARK: - Data Models

// This struct matches the JSON format from the "list all breeds" endpoint
struct BreedsResponse: Decodable {
    let message: [String: [String]] // Key: breed name, Value: sub-breeds (not used here)
}

// This struct matches the JSON format from the "random image" endpoint
struct ImageResponse: Decodable {
    let message: String // URL string of the image
}

// MARK: - Main View (List of Dog Breeds)

struct ContentView: View {
    // This state variable will hold the list of dog breeds
    @State private var breeds: [String] = []
    
    // These handle error messages and alert visibility
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            List(breeds, id: \.self) { breed in
                // Each list item links to a detail view for that breed
                NavigationLink(destination: BreedDetailView(breed: breed)) {
                    Text(breed.capitalized) // Capitalize for better appearance
                }
            }
            .navigationTitle("Dog Breeds") // Title for the navigation bar
        }
        .onAppear(perform: loadBreeds) // Call API when view appears
        .alert(isPresented: $showAlert) {
            // Show an alert if there's an error
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

   
