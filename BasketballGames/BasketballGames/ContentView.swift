//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var score: BasketballScore
    var date: String
    var isHomeGame: Bool
}

struct BasketballScore: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            List(results, id: \.id) { game in
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(game.team) Game")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Opponent: \(game.opponent)")
                        .font(.headline)
                    
                    Text("Date: \(game.date)")
                        .font(.subheadline)
                    
                    HStack {
                        Text("UNC: \(game.score.unc)")
                            .font(.subheadline)
                        Spacer()
                        Text("Opponent: \(game.score.opponent)")
                            .font(.subheadline)
                    }
                    
                    Text(game.isHomeGame ? "Home Game" : "Away Game")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
            .navigationTitle("Basketball Games")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else { return }
        
        let (data, _) = try! await URLSession.shared.data(from: url)
        let decodedResponse = try! JSONDecoder().decode([Result].self, from: data)
        results = decodedResponse
    }
}

#Preview {
    ContentView()
}
