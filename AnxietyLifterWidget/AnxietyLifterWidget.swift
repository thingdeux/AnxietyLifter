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
    enum Constants {
        static let dataPlaceHolder = WidgetAlertStateData(state: .caution,
                                                          text: ("0%", "0", "10%"),
                                                          lastUpdated: "")
    }
    
    // Initial data on first load
    func placeholder(in context: Context) -> SimpleEntry {
        print("🔧 Getting Placeholder for Widget")
        return SimpleEntry(date: Date(), data: Constants.dataPlaceHolder, relevance: nil)
    }

    // Some snapshot of data for a given time.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("🔧 Getting Snapshot for Widget")
        if (context.isPreview) {
            print("🔧 Retrieving Snapshot Data for Widget")
            completion(SimpleEntry(date: Date(), data: Constants.dataPlaceHolder, relevance: nil))
        } else {
            print("🔧 Retrieving Actual Data for Widget")
            HHSApiService.retrieveLatestStoredData { data in
                let dataToPrint: String = data.debugDescription ?? "Uh Oh"
                print("🔧 Data Retrieved for Widget \(dataToPrint)")                
                completion(SimpleEntry(date: Date(), data: data, relevance: nil))
            }
        }
    }

    // Determine how often to refresh data
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        print("🔧 Setting Timeline")
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries three hours apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 4 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset * 5, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    data: nil,
                                    relevance: (hourOffset == 0) ? TimelineEntryRelevance(score: 100) : nil)
            entries.append(entry)
            if hourOffset == 0 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, data: nil,
                                        relevance: TimelineEntryRelevance(score: 100))
                entries.append(entry)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        print("Now ->> \(currentDate)")
        print("TimeLines -> \(timeline)")
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: WidgetAlertStateData?
    let relevance: TimelineEntryRelevance?
}

@main
struct AnxietyLifterWidget: Widget {
    let kind: String = "AnxietyLifterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetMainView(entry: entry)
        }
        .configurationDisplayName("Anxiety Lifter")
        .description("Free your Covid-19 Anxiety")
        .supportedFamilies([.systemSmall])
    }
}

struct AnxietyLifterWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMainView(entry: SimpleEntry(date: Date(), data: Provider.Constants.dataPlaceHolder, relevance: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
