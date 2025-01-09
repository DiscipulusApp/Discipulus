import Foundation
import SwiftUI

func formatDate(_ date: Date, timeInterval: TimeInterval, short: Bool = false) -> String {
    if timeInterval <= 0 {
        return "Nu"
    }
    
    let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: date.addingTimeInterval(timeInterval))
    
    if let day = components.day, day > 0 {
        return "in \(day)\(short ? "d" : day > 1 ? " dagen" : " dag")"
    } else if let hour = components.hour, hour > 0 {
        return "in \(hour)\(short ? "u" : hour > 1 ? " uren" : " uur")"
    } else if let minute = components.minute, minute > 0 {
        return "in \(minute)\(short ? "m" : " min")"
    }
    
    return "Nu"
}

func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

func formatDateHeader(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "nl-NL_POSIX")
    formatter.dateFormat = "EEEE d MMMM"
    return formatter.string(from: date)
}

func getWidgetColors(for colorScheme: ColorScheme, native: Bool = true) -> WidgetColors {
    let widgetColors: WidgetColors = WidgetColors()
    let sharedDefaults = UserDefaults(suiteName: "group.DUGUWCFH8P.dev.harrydekat.discipulus")
    
    if let colorData = sharedDefaults?.dictionary(forKey: "colors") as? [String: Int] {
            
        var background = Color(rgb: colorData["background"] ?? 0xFFFFFF)
        var primary = Color(rgb: colorData["primary"] ?? 0xFFFFFF)
        var done = Color(rgb: colorData["done"] ?? 0xFFFFFF)
        var test = Color(rgb: colorData["test"] ?? 0xFFFFFF)
        var secondary = Color(rgb: colorData["secondary"] ?? 0xFFFFFF)

        if colorScheme == .dark {
            background = Color(rgb: colorData["darkBackground"] ?? 0xFFFFFF)
            primary = Color(rgb: colorData["darkPrimary"] ?? 0xFFFFFF)
            done = Color(rgb: colorData["darkDone"] ?? 0xFFFFFF)
            test = Color(rgb: colorData["darkTest"] ?? 0xFFFFFF)
            secondary = Color(rgb: colorData["darkSecondary"] ?? 0xFFFFFF)
        }

        if (!native) {
            widgetColors.background = background
            widgetColors.primary = primary
            widgetColors.done = done
            widgetColors.test = test
            widgetColors.secondary = secondary
        }
    }
    
    return widgetColors
}

extension Color {
    init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
}

class WidgetColors {
    var background: SwiftUI.Color = ({ 
        #if canImport(UIKit)
            return Color(.systemBackground)
        #elseif canImport(AppKit)
            return Color(.windowBackgroundColor)
        #endif
    })()
    var primary: SwiftUI.Color = .accentColor
    var done: SwiftUI.Color = .green
    var test: SwiftUI.Color = .indigo
    var secondary: SwiftUI.Color = .secondary
}
