import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
    let entry: SimpleEntry
    
    var body: some View {
        let leading = Image(systemName: "calendar")
        
        if let event = entry.upcomingEvents.first(where: {
            $0.startTime > entry.date.addingTimeInterval(-300) && $0.startTime <= entry.date.addingTimeInterval(3600 * 24 * 7)
        }) {
            
            let timeRemaining: TimeInterval = event.startTime.timeIntervalSince(entry.date)
            let timeString = timeRemaining < 3600 * 12 ? "om \(formatTime(event.startTime))" : formatDate(entry.date, timeInterval: timeRemaining)
            
            ViewThatFits {
                if let location = event.location {
                    Text("\(leading) \(location) - \(event.name) \(timeString)")
                    
                    if let shortName = event.shortName {
                        Text("\(leading) \(location) - \(shortName) \(timeString)")
                    } else {
                        Text("\(leading) \(location) - \(event.name.prefix(4)) \(timeString)")
                    }
                    
                    Text("\(Image(systemName: "location.fill")) \(location) \(timeString)")
                    
                    Text("\(Image(systemName: "location.fill")) \(location)")
                } else {
                    Text("\(leading) \(event.name) \(timeString)")
                    
                    if let shortName = event.shortName {
                        Text("\(leading) \(shortName) \(timeString)")
                    }
                }
            }
        } else {
            ViewThatFits {
                Text("🏖️ Geen komende lessen")
                Text("🏖️ Geen lessen")
                Text("🏖️ Vrij")
            }
        }
    }
}
