//
//  StockPurchaseViewModel.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import Foundation
import ActivityKit

class StockPurchaseViewModel: ObservableObject {
  @Published private(set) var quantity: Int = 10
  @Published private(set) var activity: Activity<StockTradingAttributes>?
  @Published private(set) var currentPrice = 0.0
  @Published private(set) var position = 0.0

  func buy(stock: Stock) {
    currentPrice = .random(in: stock.minimumPrice..<stock.maximumPrice)
    position = (currentPrice - stock.price) * Double(quantity)

    let contentState = StockTradingAttributes.ContentState(position: position, currentPrice: currentPrice, tradeState: .ongoing)
    let attributes = StockTradingAttributes(stock: stock, quantity: quantity)

    do {
      activity = try Activity.request(attributes: attributes, contentState: contentState)

      Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
        self.update(for: stock)
      }
    } catch (let error) {
      print("Error requesting stock trade Live Activity \(error.localizedDescription).")
    }
  }

  func sell(stock: Stock) {
    currentPrice = .random(in: stock.minimumPrice..<stock.maximumPrice)
    position = (stock.price - currentPrice) * Double(quantity)

    let contentState = StockTradingAttributes.ContentState(position: position, currentPrice: currentPrice, tradeState: .ongoing)
    let attributes = StockTradingAttributes(stock: stock, quantity: quantity)

    do {
      activity = try Activity.request(attributes: attributes, contentState: contentState)
    } catch (let error) {
      print("Error requesting stock trade Live Activity \(error.localizedDescription).")
    }
  }

  func endTrade(for stock: Stock) async {
    let contentState = StockTradingAttributes.ContentState(position: position, currentPrice: currentPrice, tradeState: .ended)

    await activity?.end(using: contentState, dismissalPolicy: .default)
  }

  func incrementQuantity() {
    if quantity < 50 {
      quantity += 1
    }
  }

  func decrementQuantity() {
    if quantity > 0 {
      quantity -= 1
    }
  }

  private func update(for stock: Stock) {
    let currentPrice: Double = .random(in: stock.minimumPrice..<stock.maximumPrice)
    let position = (currentPrice - stock.price) * Double(quantity)

    let priceStatus = StockTradingAttributes.ContentState(position: position, currentPrice: currentPrice, tradeState: .ongoing)
    Task {
      await activity?.update(using: priceStatus)
    }
  }
}
