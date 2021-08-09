//
//  AnxietyLifterWidget.swift
//  AnxietyLifterWidget
//
//  Created by Joshua Danger on 8/8/21.
//

import WidgetKit
import SwiftUI
import Intents
import AnxietyLifterCore

struct Provider: IntentTimelineProvider {
    // Initial data on first load
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    // Some snapshot of data for a given time.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct AnxietyLifterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.opacity(0.90)
            HStack(spacing: 0) {
                StopLightView(.go)
                    .frame(width: 80, height: 140)
                    .previewContext(WidgetPreviewContext(family: .systemSmall))
                    .padding(6)
                
                VStack {
                    Text("Updated: 6/12/21")
                        .font(.caption2)
                        .foregroundColor(.white)
                    
                    Text("Note: Nothing")
                        .font(.caption2)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
    }
}

@main
struct AnxietyLifterWidget: Widget {
    let kind: String = "AnxietyLifterWidget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            AnxietyLifterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Anxiety Lifter")
        .description("Free your Covid-19 Anxiety")
    }
}

struct AnxietyLifterWidget_Previews: PreviewProvider {
    static var previews: some View {
        AnxietyLifterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
