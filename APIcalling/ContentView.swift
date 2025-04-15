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

    // This function fetches the list of breeds from the Dog API
    func loadBreeds() {
        // Create the URL from the API string
        guard let url = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            self.errorMessage = "Invalid URL."
            self.showAlert = true
            return
        }

        // Make the API request
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
                return
            }

            // Handle missing data
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                    self.showAlert = true
                }
                return
            }

            // Try to decode the JSON data into our struct
            do {
                let decodedResponse = try JSONDecoder().decode(BreedsResponse.self, from: data)
                
                // Extract the breed names (keys) and sort them alphabetically
                let allBreeds = decodedResponse.message.keys.sorted()
                
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.breeds = allBreeds
                }
            } catch {
                // Handle JSON decoding errors
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON."
                    self.showAlert = true
                }
            }
        }.resume() // Start the network request
    }
}

// MARK: - Detail View (Shows Image for Selected Breed)

struct BreedDetailView: View {
    var breed: String // Passed in from ContentView
    @State private var imageURL: String = "" // Will hold the image URL
    @State private var showAlert = false // For handling errors

    var body: some View {
        VStack {
            // If a valid image URL is available, show it
            if let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(20)
                } placeholder: {
                    // Show a spinner while the image loads
                    ProgressView()
                }
            } else {
                // Fallback if image URL is not valid
                Text("Image not available.")
            }

            Spacer()
        }
        .padding()
        .navigationTitle(breed.capitalized) // Title of the detail view
        .onAppear(perform: loadImage) // Load the image when view appears
        .alert(isPresented: $showAlert) {
            // Show alert if something goes wrong
            Alert(title: Text("Error"), message: Text("Failed to load image."), dismissButton: .default(Text("OK")))
        }
    }

    // This function fetches a random image URL for the selected breed
    func loadImage() {
        // Create the API URL with the selected breed
        guard let url = URL(string: "https://dog.ceo/api/breed/\(breed)/images/random") else {
            self.showAlert = true
            return
        }

        // Make the network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors or decode the image URL
            guard let data = data,
                  let decoded = try? JSONDecoder().decode(ImageResponse.self, from: data) else {
                DispatchQueue.main.async {
                    self.showAlert = true
                }
                return
            }

            // Update the UI with the image URL
            DispatchQueue.main.async {
                self.imageURL = decoded.message
            }
        }.resume()
    }
}


#Preview {
    ContentView()
}
