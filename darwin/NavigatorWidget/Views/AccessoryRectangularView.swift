import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
    let entry: SimpleEntry

    var body: some View {
        if let event = entry.upcomingEvents.first(where: {
            $0.startTime > entry.date.addingTimeInterval(-300) && $0.startTime <= entry.date.addingTimeInterval(3600 * 24 * 7)
        }) {
            HStack(spacing: 10) {
                if let location = event.location {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 44, height: 44)

                        Circle()
                            .fill(Material.thick)
                            .frame(width: 44, height: 44)
                            .blur(radius: 5)

                        Text(location.prefix(4))
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .widgetAccentable()
                    }
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
                } else {
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                        .fill(Color.accentColor)
                        .frame(width: 4, height: 44)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.name)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .lineLimit(1)
                    Text(event.startTime, style: .relative)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                if event.location == nil {
                    Spacer()
                }
            }
        } else {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Color.blue.opacity(0.15))

                RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                    .fill(Material.thin)
                    .blur(radius: 5)

                HStack(spacing: 8) {
                    Text("📅")

                    Text("Geen lessen gepland")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .widgetAccentable()
                }
            }
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
        }
    }
}
