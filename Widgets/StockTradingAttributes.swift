//
//  StockTradingAttributes.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import ActivityKit

struct StockTradingAttributes: ActivityAttributes {
  enum TradeState: Codable {
    case ongoing
    case ended
  }

  public struct ContentState: Codable, Hashable {
    var position: Double
    var currentPrice: Double
    var tradeState: TradeState
  }

  var stock: Stock
  var quantity: Int
}
