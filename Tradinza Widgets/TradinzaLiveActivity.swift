//
//  TradinzaLiveActivity.swift
//  Tradinza Widgets
//
//  Created by Rudrank Riyam on 02/10/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

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

struct TradinzaLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: StockTradingAttributes.self) { context in
      CurrentTradeView(context: context)
        .padding()
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.bottom) {
            EmptyView()
        }
      } compactLeading: {
          EmptyView()
      } compactTrailing: {
          EmptyView()
      } minimal: {
          EmptyView()
      }
    }
  }
}

struct CurrentTradeView: View {
  var context: ActivityViewContext<StockTradingAttributes>

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        Text(context.attributes.stock.name).bold()
          .font(.title2)

        Text("Qty: ") + Text(context.attributes.quantity, format: .number).monospacedDigit()

        Text("Price: ") + Text(context.attributes.stock.price, format: .number).monospacedDigit()
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 8) {
        Text("P&L: ").bold()
          .font(.title2) +
        CurrentTradePAndLView(context: context, font: .title2).body

        Text("SELL")

        Text("LTP: ") + Text(String(format: "%.2f", context.state.currentPrice)).monospacedDigit()
      }
    }
    .foregroundColor(.gray)
    .activityBackgroundTint(Color.white)
    .activitySystemActionForegroundColor(Color.black)
  }
}

struct CurrentTradePAndLView: View {
  var context: ActivityViewContext<StockTradingAttributes>
  var font: Font

  var body: Text {
    Text(String(format: "%.2f", context.state.position))
      .monospacedDigit()
      .bold()
      .font(font)
      .foregroundColor(context.state.position >= 0 ? .green : .red)
  }
}
