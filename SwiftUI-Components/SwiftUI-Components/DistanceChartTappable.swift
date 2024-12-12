//
//  Untitled.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 12/11/24.
//

import SwiftUI
import Charts

struct DistanceChartTappable: View {
    
    @State var data: [BarActivity] = generateTestData()
    
    @State var tab = AnalyticsTab.BarSelection.month
    @State var selectedDate: Date? = nil
    @State var tabUpdateDateString: String = ""
    
    var selectedDateValue: (day: Date, now: Double)? {
        if let selectedDate {
            let nowDistances = data.filter {
                return Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            
            let now = nowDistances.reduce(0) { $0 + $1.distance }
            
            return (selectedDate, now)
        }
        
        return nil
    }
    
    func opacity(for bar: BarActivity) -> Double {
        if let selectedDate {
            if Calendar.current.isDate(selectedDate, inSameDayAs: bar.date) {
                return 1
            }
            return 0.5
        } else { return 1 }
    }
    
    var timeInterval: TimeInterval {
        switch tab {
        case .day: return 60 * 60 * 24
        case .week: return 60 * 60 * 24 * 7
        case .month: return 60 * 60 * 24 * 31
        }
    }
    
    var maxX: Date {
        data.last?.date ?? .now
    }
    
    var body: some View {
        
        VStack(spacing: 5) {
            HStack(alignment: .center) {
                Spacer()
                Picker("", selection: $tab) {
                    Text("Day")
                        .tag(AnalyticsTab.BarSelection.day)
                    Text("Week")
                        .tag(AnalyticsTab.BarSelection.week)
                    Text("Month")
                        .tag(AnalyticsTab.BarSelection.month)
                    
                }
                .pickerStyle(.segmented)
                .sensoryFeedback(.selection, trigger: tab)
                Spacer()
            }
            
            if let selectedDateValue {
                HStack {
                    VStack(alignment: .leading) {
                        Text("DISTANCE")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                        
                        HStack {
                            Text(String(format: "%.2f", selectedDateValue.now))
                                .font(.title)
                            Text("miles")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                        Text(selectedDateValue.day.formatted(date: .complete, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                        
                    }
                    Spacer()
                }
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("AVERAGE")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                        
                        HStack {
                            Text("2,405")
                                .font(.title)
                            Text("miles")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                        Text(tabUpdateDateString)
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                        
                    }
                    Spacer()
                }
            }
            
            Chart {
                ForEach(data) { bar in
                    BarMark(
                        x: .value("Current", bar.date, unit: tab.unit),
                        y: .value("Miles", bar.distance.rounded())
                    )
                    .cornerRadius(tab.cornerRadius)
                    .foregroundStyle(.blue.gradient)
                    .opacity(opacity(for: bar))
                }
                
                if let selectedDate, selectedDate <= maxX {
                    RuleMark(x: .value("Current", selectedDate, unit: .day))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .foregroundStyle(.gray.tertiary)
                }
            }
            
            .chartYScale(domain: 1...25)
            .chartScrollableAxes(.horizontal)
            .chartXAxis {
                AxisMarks(values: .stride(by: tab.unit, count: tab.strideCount)) { value in
                    AxisGridLine()
                    AxisTick()
                    if tab == .day {
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day(.twoDigits).hour(.defaultDigits(amPM: .abbreviated)))
                    }
                    if tab == .week {
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day(.twoDigits).weekday(.narrow))
                    }
                    if tab == .month {
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day(.defaultDigits))
                    }
                }
            }
            .chartXVisibleDomain(length: timeInterval)
            .chartScrollTargetBehavior(
                .valueAligned(
                    matching: tab.dateComponentMatching,
                    majorAlignment: .matching(tab.dateComponentMajor),
                    limitBehavior: .automatic
                )
            )
            .chartScrollPosition(initialX: Date.now.startOfMonth.timeIntervalSinceReferenceDate)
            .chartXSelection(value: $selectedDate)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

func generateTestData() -> [BarActivity] {
    var test = [BarActivity]()
    var threeYears = 365 * 3
    for i in 0...threeYears {
        let date = Calendar.current.date(byAdding: .day, value: -1 * i, to: .now)!
        let distance = Double.random(in: 0...20)
        test.append(BarActivity(date: date, distance: distance, animate: true))
    }
    
    let zerosBuffer = Calendar.current.dateComponents([.day], from: .now, to: .now.endOfMonth).day ?? 0
    
    for i in 1..<zerosBuffer+1 {
        let date = Calendar.current.date(byAdding: .day, value: 1 * i, to: .now)!
        test.append(BarActivity(date: date, distance: 0, animate: true))
    }
    return test.sorted(by: <)
}

enum AnalyticsTab: Hashable {
    case distance
    
    var title: String {
        switch self {
        case .distance: return "Distance"
        }
    }
    
    enum Selection: Hashable {
        case week
        case month
        //        case year
        case allTime
    }
    
    enum BarSelection: Hashable {
        case day
        case week
        case month
        
        
        var unit: Calendar.Component {
            switch self {
            case .day: return .hour
            case .week: return .day
            case .month: return .day
            }
        }
        
        var strideCount: Int {
            switch self {
            case .day: return 12
            case .week: return 3
            case .month: return 7
            }
        }
        
        var dateComponentMatching: DateComponents {
            switch self {
            case .day: return DateComponents(minute: 0)
            case .week: return DateComponents(hour: 0)
            case .month: return DateComponents(hour: 0)
            }
        }
        
        /// Snap on scroll
        var dateComponentMajor: DateComponents {
            switch self {
            case .day: return DateComponents(hour: 0)
            case .week: return DateComponents(weekday: 1)
            case .month: return DateComponents(day: 1)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .day: return 1
            case .week: return 5
            case .month: return 2
            }
        }
    }
}
struct BarActivity: Identifiable, Codable, Comparable, Hashable {
    
    var id: UUID = .init()
    let date: Date
    let distance: Double
    var animate: Bool = false
    
    static func < (lhs: BarActivity, rhs: BarActivity) -> Bool {
        return lhs.date < rhs.date
    }
}
