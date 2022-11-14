//
//  CurrentTradeView.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import SwiftUI
import ActivityKit
import WidgetKit

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
