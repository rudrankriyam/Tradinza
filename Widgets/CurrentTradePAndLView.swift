//
//  CurrentTradePAndLView.swift
//  Tradinza
//
//  Created by Rudrank Riyam on 14/11/22.
//

import SwiftUI
import WidgetKit
import ActivityKit

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
