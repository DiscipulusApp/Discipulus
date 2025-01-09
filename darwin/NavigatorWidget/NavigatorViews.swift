import SwiftUI
import WidgetKit

struct NavigatorWidgetEntryView : View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SystemSmallView(entry: entry)
            case .systemMedium:
                SystemMediumView(entry: entry)
            case .systemLarge:
                SystemLargeView(entry: entry)
            @unknown default:
                if #available(iOS 14.0, macOS 11.0, *), family == .systemExtraLarge {
                    SystemExtraLargeView(entry: entry)
                } else if #available(iOS 16.0, *) {
                    switch family {
                    case .accessoryInline:
                        AccessoryInlineView(entry: entry)
                    case .accessoryCircular:
                        AccessoryCircularView(entry: entry)
                    case .accessoryRectangular:
                        AccessoryRectangularView(entry: entry)
                    default:
                        Text("Unsupported widget size")
                    }
                } else {
                    Text("Unsupported widget size")
                }
            }
        }
        .modifier(WidgetBackgroundModifier(colorScheme: colorScheme, useDiscipulusColorscheme: !entry.configuration.useDiscipulusColorscheme))
    }
}

struct WidgetBackgroundModifier: ViewModifier {
    let colorScheme: ColorScheme
    let useDiscipulusColorscheme: Bool
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            content.containerBackground(for: .widget) {
                getWidgetColors(for: colorScheme, native: useDiscipulusColorscheme).background
            }
        } else {
            content.background(getWidgetColors(for: colorScheme, native: useDiscipulusColorscheme).background)
        }
    }
}
