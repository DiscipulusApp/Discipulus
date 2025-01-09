import SwiftUI
import WidgetKit

struct SystemSmallView: View {
    @Environment(\.configurationIntent) var configuration
    @Environment(\.colorScheme) var colorScheme
    let entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let event = entry.currentEvents.first {
                eventDetailView(event: event).id(event.id).transition(.push(from: .bottom))
            } else {
                Text("Geen lessen vandaag")
                    .font(.headline)
            }
            
            HStack {
                Spacer()
            }
            
            Spacer()
            
            if entry.currentEvents.count > 1 {
                eventTile(event: entry.currentEvents.dropFirst().first!, currentDate: entry.date)
            } else if !entry.currentEvents.isEmpty {
                Text("Geen volgende les vandaag")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else if let passedEventsCount = getPassedEventsCount(entry: entry), passedEventsCount != 0 {
                Text("\(passedEventsCount) \(passedEventsCount > 1 ? "lessen" : "les") gepasseerd")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                Text("Wat een feest")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func eventDetailView(event: Event) -> some View {
        VStack(alignment: .leading) {
            Text(event.location ?? "Geen locatie")
                .foregroundColor(event.infotypeColor(for: colorScheme, native: !configuration.useDiscipulusColorscheme))
                .font(.title3)
                .fontWeight(.bold)
            
            Text(event.name)
                .font(.headline)
            
            Text(event.startTime, style: .relative)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    func getPassedEventsCount(entry: SimpleEntry) -> Int? {
        let passedEvents = entry.events.filter { $0.endTime <= entry.date && Calendar.current.isDateInToday($0.startTime) }
        return passedEvents.isEmpty ? nil : passedEvents.count
    }
}
