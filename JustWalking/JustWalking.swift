//
//  JustWalking.swift
//  JustWalking
//
//  Created by Jacob LeCoq on 3/21/21.
//

import WidgetKit
import SwiftUI

struct StepEntry: TimelineEntry {
    var date: Date = Date()
    var steps: Int
    var distance: Double
}

struct Provider: TimelineProvider {
    typealias Entry = StepEntry
    
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.lecoqjacob.justwalking"))
    var stepCount: Int = 0
    @AppStorage("distanceCount", store: UserDefaults(suiteName: "group.com.lecoqjacob.justwalking"))
    var distanceCount: Double = 0
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = StepEntry(steps: stepCount, distance: distanceCount)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = StepEntry(steps: stepCount, distance: distanceCount)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
    
    func placeholder(in context: Context) -> StepEntry {
        return StepEntry(steps: 0, distance: 0)
    }
    
}


struct StepView: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Steps: \(entry.steps)")
            Text(String(format: "%.2f miles", entry.distance))
        }
    }
}

@main
struct StepWidget: Widget {
    private let kind = "StepWidget"
    
    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StepView(entry: entry)
        }
        
    }
}
