//
//  ContentView.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import SwiftUI

struct StockPurchaseView: View {
  @ObservedObject var viewModel: StockPurchaseViewModel
  var stock: Stock
  
  var body: some View {
    Stepper(label: {
      HStack {
        GenericButton(title: "BUY", tint: .green, action: { viewModel.buy(stock: stock) })

        GenericButton(title: "SELL", tint: .orange, action: { viewModel.sell(stock: stock) })

        GenericButton(title: "END", tint: .red, action: { await viewModel.endTrade(for: stock) })

        Spacer()
        
        Text(viewModel.quantity, format: .number).font(.caption).bold()
      }
    }, onIncrement: {
      viewModel.incrementQuantity()
    }, onDecrement: {
      viewModel.decrementQuantity()
    })
  }
}

struct GenericButton: View {
  var title: String
  var tint: Color
  var action: () async -> ()

  var body: some View {
    Button(action: {
      Task {
        await action()
      }
    }, label: {
      Text(title)
        .bold()
        .font(.caption)
    })
    .buttonStyle(.borderedProminent)
    .tint(tint)
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
