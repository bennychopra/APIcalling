//
//  ContentView.swift
//  APIcalling
//
//  Created by Benny Chopra on 4/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Click Here Cool Dogs", destination: dogs())
                    .font(Font.custom("Market Felt",size: 40))
                Image("dog")
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .ignoresSafeArea()
            }
        }
    }
}
#Preview {
    ContentView()
}

struct title: View {
    let text: String
    var body: some View {
        Text(text).font(.custom("Market Felt", size: 55))
    }
}
