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

