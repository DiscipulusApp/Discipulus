import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
    let entry: SimpleEntry
    
    var body: some View {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                
                Circle()
                    .fill(Material.thick)
                    .blur(radius: 5)
                
                if let event = entry.upcomingEvents.first(where: {
                    $0.startTime > entry.date.addingTimeInterval(-300) && $0.startTime <= entry.date.addingTimeInterval(3600 * 24 * 7)
                }) {
                    VStack {
                        Text(event.location?.prefix(4) ?? "???")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .widgetAccentable()
                        Text(event.shortName ?? String(event.name.prefix(4)))
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                        
                    }
                } else {
                    Text("🏖️")
                }
            
            }
            .clipShape(Circle())
        
    }
}
