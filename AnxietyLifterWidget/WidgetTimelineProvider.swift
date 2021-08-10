//
//  WidgetTimelineProvider.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/10/21.
//

import WidgetKit
import SwiftUI
import Intents
import AnxietyLifterCore

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: WidgetAlertStateData
    let relevance: TimelineEntryRelevance?
}

struct Provider: TimelineProvider {
    enum Constants {
        static let dataPlaceHolder = WidgetAlertStateData(state: .none,
                                                          text: ("- -", "- -", "- -"),
                                                          lastUpdated: "")
        static let delayBetweenChecksInHours = 2
    }
    
    // Mock Data for Widget preview context.
    func placeholder(in context: Context) -> SimpleEntry {
        let placeHolder = WidgetAlertStateData(state: .stop, text: ("50%", "50", "10%"), lastUpdated: "02/17/1984")
        return SimpleEntry(date: Date(), data: placeHolder, relevance: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        print("🔧 Getting Snapshot for Widget")
        if (context.isPreview) {
            completion(placeholder(in: context))
        } else {
            print("🔧 Retrieving Actual Data for Widget")
            HHSApiService.retrieveLatestStoredData { data in
                print("🔧 Data Retrieved for Widget \(data.debugDescription)")
                completion(SimpleEntry(date: Date(), data: data ?? Constants.dataPlaceHolder, relevance: nil))
            }
        }
    }
    
    private func determineRelevanceByTime(hour: Int) -> TimelineEntryRelevance? {
        // If it's early in the morning - set high relevance
        switch (hour) {
        case 6...9: return TimelineEntryRelevance(score: 100)
        case 10...12: return TimelineEntryRelevance(score: 40)
        default: return nil
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        print("🔧 Setting Timeline")
        
        // Check again in 2 hours.
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: Constants.delayBetweenChecksInHours, to: currentDate)!
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        
        print("🔧 Retrieving Actual Data for Widget")
        HHSApiService.retrieveLatestStoredData { data in
            guard let data = data else {
                print("🔧 Retrieve Latest Stored data comes up nil! Using placeholder!")
                let entry = SimpleEntry(date: entryDate,
                                        data: Constants.dataPlaceHolder,
                                        relevance: nil)
                            
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
                return
            }
                        
            print("🔧 Data Retrieved for Widget \(data)")
            let entry = SimpleEntry(date: entryDate, data: data,
                                    relevance: determineRelevanceByTime(hour: currentHour))
                        
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}
