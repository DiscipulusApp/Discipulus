import WidgetKit
import SwiftUI

struct ConfigurationIntentKey: EnvironmentKey {
    static let defaultValue: ConfigurationIntent = ConfigurationIntent()
}

extension EnvironmentValues {
    var configurationIntent: ConfigurationIntent {
        get { self[ConfigurationIntentKey.self] }
        set { self[ConfigurationIntentKey.self] = newValue }
    }
}

@main
struct NavigatorWidget: Widget {
    let kind: String = "NavigatorWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NavigatorWidgetEntryView(entry: entry).environment(\.configurationIntent, entry.configuration)
        }
        .configurationDisplayName("Komende lessen")
        .description("Zie waar je volgende les of lessen zijn")
        .supportedFamilies(supportedFamilies())
    }

    private func supportedFamilies() -> [WidgetFamily] {
        var families: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge
        ]
        
        /// Only iOS supports these widgets families for now.
        #if os(iOS)
        families.append(contentsOf: [
            .accessoryCircular,
            .accessoryInline,
            .accessoryRectangular
        ])
        #endif

        return families
    }
}

struct NavigatorWidget_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), events: sampleEvents))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
