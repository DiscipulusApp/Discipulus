import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let events: [Event]
    
    var currentEvents: [Event] {
        events
            .filter { event in Calendar.current.isDate(event.startTime, inSameDayAs: date) && event.startTime > date.addingTimeInterval(-60 * 5) }
            .sorted { $0.startTime < $1.startTime }
    }
    
    var upcomingEvents: [Event] {
        events
            .filter { $0.endTime > date }
            .filter { event in
                (configuration.displayedEventType == DisplayedEventType.homework && event.infoType == 1) ||
                (configuration.displayedEventType == DisplayedEventType.tests && [2,3,4,5].contains(where: { $0 == event.infoType }) ) ||
                (configuration.displayedEventType == DisplayedEventType.homework_and_tests && [1,2,3,4,5].contains(where: { $0 == event.infoType })) ||
                (configuration.displayedEventType == DisplayedEventType.all)
            }
            .sorted { $0.startTime < $1.startTime }
    }
}
