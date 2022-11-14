//
//  TradinzaLiveActivity.swift
//  Widgets
//
//  Created by Rudrank Riyam on 14/11/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TradinzaLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: StockTradingAttributes.self) { context in
      CurrentTradeView(context: context)
        .padding()
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.bottom) {
          CurrentTradeView(context: context)
        }
      } compactLeading: {
        Text(context.attributes.stock.symbol).bold()
          .foregroundColor(.white)
      } compactTrailing: {
        CurrentTradePAndLView(context: context, font: .body)
      } minimal: {
        CurrentTradePAndLView(context: context, font: .body)
      }
    }
  }
}
