import SwiftUI

struct eventTile: View {
    @Environment(\.configurationIntent) var configuration
    @Environment(\.colorScheme) var colorScheme
    let event: Event
    let currentDate: Date

    var body: some View {
        HStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                .fill(event.infotypeColor(for: colorScheme, native: !configuration.useDiscipulusColorscheme))
                .frame(width: 4)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(event.location != nil ? 1 : 2)
                if let subtitle = [
                    (event.startHourIndicator == nil ? formatTime(event.startTime) : nil),
                    event.location,
                    event.infotypeShortString
                ].compactMap({ $0 }) as? [String], !subtitle.isEmpty {
                    Text(subtitle.joined(separator: " • "))
                        .font(.caption2)
                }
            }
            
           
                if let startHourIndicator = event.startHourIndicator {
                    Spacer()
                    if startHourIndicator != event.endHourIndicator, let endHourIndicator = event.endHourIndicator {
                        Text("\(startHourIndicator)/\(endHourIndicator)u").font(.caption2)
                            .foregroundColor(.secondary)
                    } else {
                        Text("\(startHourIndicator)u").font(.caption2)
                            .foregroundColor(.secondary)
                    }
                        
                }
            
            
        }
        .frame(maxHeight: event.startHourIndicator == event.endHourIndicator ? 35 : 70)
        .id(event.id)
        .modifier(PushTransitionModifier())
    }
}

struct PushTransitionModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, *) {
            content.transition(.push(from: .trailing))
        } else {
            content.transition(.opacity)
        }
    }
}
