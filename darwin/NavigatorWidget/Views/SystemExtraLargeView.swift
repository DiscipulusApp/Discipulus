import SwiftUI
import WidgetKit

struct SystemExtraLargeView: View {
    let entry: SimpleEntry
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 16) {
                firstColumn(entry: entry, geometry: geometry)
                Divider()
                MergingColumnsView(entry: entry, geometry: geometry)
            }.padding(.horizontal, 8)
        }
    }
    
    func firstColumn(entry: SimpleEntry, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SystemSmallView(entry: entry).frame(width: geometry.size.width / 4 - 28)
            if entry.currentEvents.count >= 2 {
                upcomingEventsList(entry: entry, prefix: 6, filteredDate: entry.date)
            }
        }
        .frame(width: geometry.size.width / 4 - 28)
    }
}

struct MergingColumnsView: View {
    let entry: SimpleEntry
    let geometry: GeometryProxy
    
    var body: some View {
        let columns: [AnyView?] = [
            secondColumnContent(entry: entry, geometry: geometry),
            thirdColumnContent(entry: entry, geometry: geometry),
            fourthColumnContent(entry: entry, geometry: geometry)
        ]
        
        let nonEmptyColumns = columns.compactMap { $0 }
        
        return Group {
            if nonEmptyColumns.isEmpty {
                EmptyColumnView(displayedEventType: entry.configuration.displayedEventType)
                    .frame(width: geometry.size.width * 3 / 4 - 44)
            } else {
                HStack(spacing: 16) {
                    ForEach(0..<nonEmptyColumns.count, id: \.self) { index in
                        nonEmptyColumns[index]
                        if index < 2 {
                            Divider()
                        }
                    }
                    if nonEmptyColumns.count < 3 {
                        EmptyColumnView(displayedEventType: entry.configuration.displayedEventType)
                    }
                }
            }
        }
    }
    
    func secondColumnContent(entry: SimpleEntry, geometry: GeometryProxy) -> AnyView? {
        let todayEvents = entry.upcomingEvents.filter { Calendar.current.isDate($0.startTime, inSameDayAs: entry.date) }
        let remainingTodayEvents = todayEvents.dropFirst(5)
        
        if !remainingTodayEvents.isEmpty {
            return AnyView(
                upcomingEventsList(entry: entry, skip: 5, filteredDate: entry.date)
                    .frame(width: geometry.size.width / 4 - 28)
            )
        } else {
            let nextDay = findNextDayWithEvents(after: entry.date, events: entry.upcomingEvents)
            return columnWithEvents(entry: entry, date: nextDay, geometry: geometry)
        }
    }
    
    func thirdColumnContent(entry: SimpleEntry, geometry: GeometryProxy) -> AnyView? {
        let secondColumnDate = findNextDayWithEvents(after: entry.date, events: entry.upcomingEvents)
        let thirdColumnDate = findNextDayWithEvents(after: secondColumnDate, events: entry.upcomingEvents)
        return columnWithEvents(entry: entry, date: thirdColumnDate, geometry: geometry)
    }
    
    func fourthColumnContent(entry: SimpleEntry, geometry: GeometryProxy) -> AnyView? {
        let secondColumnDate = findNextDayWithEvents(after: entry.date, events: entry.upcomingEvents)
        let thirdColumnDate = findNextDayWithEvents(after: secondColumnDate, events: entry.upcomingEvents)
        let fourthColumnDate = findNextDayWithEvents(after: thirdColumnDate, events: entry.upcomingEvents)
        return columnWithEvents(entry: entry, date: fourthColumnDate, geometry: geometry)
    }
    
    func columnWithEvents(entry: SimpleEntry, date: Date?, geometry: GeometryProxy) -> AnyView? {
        guard let date = date else { return nil }
        
        return AnyView(
                upcomingEventsList(entry: entry, filteredDate: date)
            .frame(width: geometry.size.width / 4 - 28)
        )
    }
    
    func findNextDayWithEvents(after date: Date?, events: [Event]) -> Date? {
        guard let startDate = date else { return nil }
        let calendar = Calendar.current
        var currentDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        while currentDate < calendar.date(byAdding: .month, value: 1, to: startDate)! {
            let eventsOnDay = events.filter { Calendar.current.isDate($0.startTime, inSameDayAs: currentDate) }
            if !eventsOnDay.isEmpty {
                return currentDate
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return nil
    }
}
