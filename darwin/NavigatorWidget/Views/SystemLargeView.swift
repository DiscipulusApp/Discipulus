import SwiftUI
import WidgetKit

struct SystemLargeView: View {
    let entry: SimpleEntry
    
    var body: some View {
        let skipped: Int = entry.currentEvents.count >= 2 ? 6 : 0
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading) {
                    SystemSmallView(entry: entry).frame(width: geometry.size.width / 2 - 24)
                    if entry.currentEvents.count >= 2 {
                        upcomingEventsList(entry: entry, prefix: skipped)
                    }
                }
                                
                Divider()
                
                if entry.upcomingEvents.dropFirst(skipped).count > entry.currentEvents.count {
                    upcomingEventsList(entry: entry, skip: skipped)
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
