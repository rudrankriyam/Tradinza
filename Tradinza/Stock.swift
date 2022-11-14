//
//  Stock.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import Foundation

struct Stock: Identifiable, Codable, Equatable, Hashable {
  var id = UUID()
  var symbol: String
  var name: String
  var price: Double
  var date = Date()
}

extension Stock {
  var maximumPrice: Double {
    price * 1.2
  }

  var minimumPrice: Double {
    price * 0.8
  }
}

extension Stock {
  static let stocks = [
    Stock(symbol: "BN", name: "Banana", price: 138.20),
    Stock(symbol: "TB", name: "TapeBook", price: 135.68),
    Stock(symbol: "RML", name: "Ramalon", price: 113.00),
    Stock(symbol: "BOOG", name: "Boogle", price: 95.65),
    Stock(symbol: "MHRD", name: "MacroHard", price: 232.90),
    Stock(symbol: "BFX", name: "BetFlex", price: 235.44),
    Stock(symbol: "STL", name: "Soutily", price: 86.30)
  ]
}
