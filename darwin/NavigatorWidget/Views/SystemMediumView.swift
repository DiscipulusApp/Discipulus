import SwiftUI
import WidgetKit

struct SystemMediumView: View {
    let entry: SimpleEntry
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 16) {
                SystemSmallView(entry: entry).frame(width: geometry.size.width / 2 - 24)
                
                Divider()
                
                if entry.upcomingEvents.count > entry.currentEvents.count {
                    upcomingEventsList(entry: entry)
                        .frame(width: geometry.size.width / 2 - 24)
                } else {
                    EmptyColumnView(
                        displayedEventType: entry.configuration.displayedEventType
                    )
                        .frame(width: geometry.size.width / 2 - 24)
                }
            }.padding(.horizontal, 8)
        }
    }
}

struct EmptyColumnView: View {
    let displayedEventType: DisplayedEventType
    
    func noEventsText(for displayedEventType: DisplayedEventType) -> String {
        switch displayedEventType {
        case .all:
            return "Geen lessen"
        case .homework:
            return "Geen huiswerk"
        case .tests:
            return "Geen toetsen"
        default:
            return "Geen huiswerk of toetsen"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("🎉")
                .font(.largeTitle)
                .padding(2)
            Text(noEventsText(for: displayedEventType))
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemBackground).opacity(0.8))
        .cornerRadius(10)
    }
}

struct upcomingEventsList: View {
    let entry: SimpleEntry
    let prefix: Int
    let skip: Int
    let filteredDate: Date?
    
    init(entry: SimpleEntry, prefix: Int = 999, skip: Int = 0, filteredDate: Date? = nil) {
        self.entry = entry
        self.prefix = prefix
        self.skip = skip
        self.filteredDate = filteredDate
    }
    
    var body: some View {
        let upcomingEvents: [Event] = {
            if let filteredDate = filteredDate {
                return entry.upcomingEvents.filter { event in
                    Calendar.current.isDate(event.startTime, inSameDayAs: filteredDate)
                }
            }
            return entry.upcomingEvents
        }()
        
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(upcomingEvents.dropFirst(skip).prefix(prefix), id: \.id) { event in
                        if !entry.currentEvents.prefix(2).contains(where: { $0.id == event.id }) && event.startTime > entry.date {
                            Group {
                                if upcomingEvents.first?.id == event.id || !Calendar.current.isDate(event.startTime, inSameDayAs: upcomingEvents[upcomingEvents.firstIndex(where: { $0.id == event.id })! - 1].startTime) {
                                    Text(formatDateHeader(event.startTime))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                eventTile(event: event, currentDate: entry.date)
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                .frame(height: geometry.size.height + 16, alignment: .top)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0),
                            .init(color: .white, location: geometry.size.height / (geometry.size.height + 16)),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}
