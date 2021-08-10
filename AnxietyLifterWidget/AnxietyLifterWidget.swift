//
//  AnxietyLifterWidget.swift
//  AnxietyLifterWidget
//
//  Created by Joshua Danger on 8/8/21.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct AnxietyLifterWidget: Widget {
    let kind: String = "AnxietyLifterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry -> WidgetMainView in
            print("🔧 Creating some LifterView \(entry)")
            return WidgetMainView(entry: entry)
        }
        .configurationDisplayName("Anxiety Lifter")
        .description("Free your Covid-19 Anxiety")
        .supportedFamilies([.systemSmall])
    }
}
