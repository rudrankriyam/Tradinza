//
//  ContentView.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 02/10/22.
//

import SwiftUI
import ActivityKit

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


struct StockPurchaseView: View {
  @ObservedObject var viewModel: StockPurchaseViewModel
  var stock: Stock

  var body: some View {
    return Stepper(label: {
      HStack {
        Button("Buy") {
          viewModel.buy(stock: stock)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue)

        Button("Sell") {
          viewModel.sell(stock: stock)
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)

        Button("End") {
          Task {
            await viewModel.endTrade(for: stock)
          }
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
        
        Spacer()

        Text(viewModel.quantity, format: .number)
      }
    }, onIncrement: {
      viewModel.incrementQuantity()
    }, onDecrement: {
      viewModel.decrementQuantity()
    })
  }
}

struct ContentView: View {
  @StateObject private var viewModel = StockPurchaseViewModel()

  var body: some View {
    NavigationStack {
      List {
        ForEach(Stock.stocks) { stock in
          DisclosureGroup(content: {
            StockPurchaseView(viewModel: viewModel, stock: stock)
          }, label: {
            StockContentRow(stock: stock)
          })
        }
      }
      .navigationTitle("Tradinza")
    }
  }
}

struct StockContentRow: View {
  var stock: Stock

  var body: some View {
    HStack {
      Text(stock.name)

      Spacer()

      Text(stock.price, format: .number)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
