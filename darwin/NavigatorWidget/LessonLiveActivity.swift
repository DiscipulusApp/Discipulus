#if os(iOS) && canImport(ActivityKit)
import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Attributes

public struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState

    public struct ContentState: Codable, Hashable {
        public var appGroupId: String?
        public init(appGroupId: String? = nil) {
            self.appGroupId = appGroupId
        }
    }

    public var id: UUID
    public init(id: UUID = UUID()) {
        self.id = id
    }
}

private let appGroup = "group.DUGUWCFH8P.dev.harrydekat.discipulus"

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String {
        "\(id)_\(key)"
    }

    /// Preview data. `minutesLeft` lets us preview the "head to next lesson" state.
    static func preview(id: UUID, minutesLeft: Double) -> LiveActivitiesAppAttributes {
        let attributes = LiveActivitiesAppAttributes(id: id)
        let defaults = UserDefaults(suiteName: appGroup)
        let now = Date()
        let end = now.addingTimeInterval(minutesLeft * 60)
        let start = end.addingTimeInterval(-45 * 60)

        func set(_ value: Any, _ key: String) {
            defaults?.set(value, forKey: attributes.prefixedKey(key))
        }

        set("Wiskunde B", "title")
        set("B12", "room")
        set("3e uur", "hourIndicator")
        set(start.timeIntervalSince1970 * 1000, "startTime")
        set(end.timeIntervalSince1970 * 1000, "endTime")
        set("Engels", "nextTitle")
        set("A04", "nextRoom")
        set(end.addingTimeInterval(15 * 60).timeIntervalSince1970 * 1000, "nextStartTime")
        set("Hierna: Pauze (15m) ➔ Engels (A04)", "afterText")
        set(true, "isOngoing")
        set(false, "isLastLesson")
        set(false, "nextDirectlyAfter")
        set(start.addingTimeInterval(4.5 * 60).timeIntervalSince1970 * 1000, "startLateThreshold")
        set(end.addingTimeInterval(-5 * 60).timeIntervalSince1970 * 1000, "endTransitionThreshold")

        return attributes
    }

    static var previewMidLesson: LiveActivitiesAppAttributes {
        preview(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, minutesLeft: 30)
    }

    static var previewEndingSoon: LiveActivitiesAppAttributes {
        preview(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, minutesLeft: 3)
    }
}

// MARK: - Data

/// What the widget shows at a given moment: an icon, a location, and a target date.
struct LessonSlot {
    let icon: String
    let location: String
    let targetDate: Date
    let isExpired: Bool
}

struct LessonActivityData {
    let title: String
    let room: String
    let hourIndicator: String
    let startDate: Date
    let endDate: Date
    let afterText: String
    let isOngoing: Bool
    let nextTitle: String
    let nextRoom: String
    let nextStart: Date?
    let isLastLesson: Bool
    let nextDirectlyAfter: Bool
    let startLateDate: Date
    let endTransitionDate: Date

    var location: String { room.isEmpty ? title : room }

    var nextLocation: String { nextRoom.isEmpty ? nextTitle : nextRoom }

    /// Dates at which the slot changes, for `TimelineView`.
    var refreshDates: [Date] {
        let now = Date()
        if !isOngoing {
            let target = nextStart ?? endDate
            if target > now {
                return [now, target]
            } else {
                return [now]
            }
        }

        var dates: [Date] = [now]
        for milestone in [startLateDate, endTransitionDate, endDate, nextStart].compactMap({ $0 }) {
            if milestone > now {
                dates.append(milestone)
            }
        }
        return Array(Set(dates)).sorted()
    }

    func slot(at date: Date) -> LessonSlot {
        if !isOngoing {
            // Pre-event / imminent / break: show navigate icon, next location, countdown to next start
            let targetLoc = nextLocation.isEmpty ? (room.isEmpty ? title : room) : nextLocation
            let target = nextStart ?? endDate
            return LessonSlot(
                icon: "arrow.turn.up.right",
                location: targetLoc,
                targetDate: target,
                isExpired: date >= target
            )
        }

        // Ongoing lesson:
        if date >= endTransitionDate {
            // End window (final 10% / ~5m)
            if nextDirectlyAfter {
                let targetLoc = nextLocation.isEmpty ? (isLastLesson ? "Vrij" : title) : nextLocation
                let target = nextStart ?? endDate
                return LessonSlot(
                    icon: "arrow.turn.up.right",
                    location: targetLoc,
                    targetDate: target,
                    isExpired: date >= target
                )
            } else {
                return LessonSlot(
                    icon: "mappin.circle.fill",
                    location: location,
                    targetDate: endDate,
                    isExpired: date >= endDate
                )
            }
        }

        // Start / late window and mid-period
        return LessonSlot(
            icon: "mappin.circle.fill",
            location: location,
            targetDate: endDate,
            isExpired: date >= endDate
        )
    }

    init(context: ActivityViewContext<LiveActivitiesAppAttributes>) {
        let defaults = UserDefaults(suiteName: appGroup)
        let attr = context.attributes
        let now = Date()

        func string(_ key: String) -> String {
            defaults?.string(forKey: attr.prefixedKey(key)) ?? ""
        }
        func bool(_ key: String, defaultVal: Bool) -> Bool {
            guard let obj = defaults?.object(forKey: attr.prefixedKey(key)) else {
                return defaultVal
            }
            if let b = obj as? Bool { return b }
            if let n = obj as? NSNumber { return n.boolValue }
            return defaultVal
        }
        func date(_ key: String) -> Date? {
            guard let obj = defaults?.object(forKey: attr.prefixedKey(key)) else { return nil }
            let ms: Double
            if let d = obj as? Double {
                ms = d
            } else if let n = obj as? NSNumber {
                ms = n.doubleValue
            } else {
                ms = 0
            }
            return ms > 0 ? Date(timeIntervalSince1970: ms / 1000) : nil
        }

        title = string("title").isEmpty ? "Les" : string("title")
        room = string("room")
        hourIndicator = string("hourIndicator")
        afterText = string("afterText")
        nextTitle = string("nextTitle")
        nextRoom = string("nextRoom")
        nextStart = date("nextStartTime")
        isLastLesson = bool("isLastLesson", defaultVal: false)
        nextDirectlyAfter = bool("nextDirectlyAfter", defaultVal: false)

        let start = date("startTime") ?? now
        let end = date("endTime") ?? start.addingTimeInterval(45 * 60)
        startDate = start
        endDate = end > start ? end : start.addingTimeInterval(60)

        isOngoing = bool("isOngoing", defaultVal: start <= now && end > now)

        let duration = endDate.timeIntervalSince(startDate)
        let defaultLate = startDate.addingTimeInterval(duration * 0.10)
        let endWindowSecs = max(duration * 0.10, min(5 * 60, duration * 0.25))
        let defaultTransition = endDate.addingTimeInterval(-endWindowSecs)

        startLateDate = date("startLateThreshold") ?? defaultLate
        endTransitionDate = date("endTransitionThreshold") ?? defaultTransition
    }
}

// MARK: - Shared views

/// Icon + location (for collapsed dynamic island).
@available(iOSApplicationExtension 16.1, *)
struct LessonLocationLabel: View {
    let data: LessonActivityData

    var body: some View {
        TimelineView(.explicit(data.refreshDates)) { timeline in
            let slot = data.slot(at: timeline.date)
            HStack(spacing: 5) {
                Image(systemName: slot.icon)
                    .foregroundStyle(.tint)
                    .font(.caption.weight(.semibold))
                Text(slot.location)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }
        }
    }
}

/// Icon only (for the minimal Dynamic Island).
@available(iOSApplicationExtension 16.1, *)
struct LessonIcon: View {
    let data: LessonActivityData

    var body: some View {
        TimelineView(.explicit(data.refreshDates)) { timeline in
            Image(systemName: data.slot(at: timeline.date).icon)
                .foregroundStyle(.tint)
        }
    }
}

/// Native ticking countdown (displays mm:ss without relative rounding artifacts).
@available(iOSApplicationExtension 16.1, *)
struct LessonTimer: View {
    let data: LessonActivityData

    var body: some View {
        TimelineView(.explicit(data.refreshDates)) { timeline in
            let slot = data.slot(at: timeline.date)
            if slot.isExpired {
                Text(data.isLastLesson ? "Vrij" : "00:00")
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(.tint)
            } else {
                Text(slot.targetDate, style: .timer)
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(.tint)
            }
        }
    }
}

// MARK: - Widget

@available(iOSApplicationExtension 16.1, *)
struct LessonLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            let data = LessonActivityData(context: context)
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            TimelineView(.explicit(data.refreshDates)) { timeline in
                                Image(systemName: data.slot(at: timeline.date).icon)
                                    .foregroundStyle(.tint)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            Text(data.title)
                                .font(.headline.weight(.bold))
                                .lineLimit(1)
                        }
                        let details = [
                            data.room.isEmpty ? nil : "Lokaal \(data.room)",
                            data.hourIndicator.isEmpty ? nil : data.hourIndicator
                        ].compactMap { $0 }.joined(separator: " • ")
                        if !details.isEmpty {
                            Text(details)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    Spacer(minLength: 12)
                    LessonTimer(data: data)
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                }

                if data.isOngoing {
                    ProgressView(
                        timerInterval: data.startDate...data.endDate,
                        countsDown: false,
                        label: { EmptyView() },
                        currentValueLabel: { EmptyView() }
                    )
                    .tint(.accentColor)
                }

                if !data.afterText.isEmpty {
                    Text(data.afterText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .widgetURL(URL(string: "discipulus://calendar"))
        } dynamicIsland: { context in
            let data = LessonActivityData(context: context)
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TimelineView(.explicit(data.refreshDates)) { timeline in
                        let slot = data.slot(at: timeline.date)
                        HStack(spacing: 6) {
                            Image(systemName: slot.icon)
                                .foregroundStyle(.tint)
                                .font(.system(size: 14, weight: .bold))
                            if !slot.location.isEmpty {
                                Text(slot.location)
                                    .font(.subheadline.weight(.bold))
                                    .lineLimit(1)
                            }
                        }
                        .padding(.leading, 8)
                        .padding(.top, 4)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    LessonTimer(data: data)
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 8)
                        .padding(.top, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(data.title)
                            .font(.title3.weight(.bold))
                            .lineLimit(1)

                        let details = [
                            data.room.isEmpty ? nil : "Lokaal \(data.room)",
                            data.hourIndicator.isEmpty ? nil : data.hourIndicator
                        ].compactMap { $0 }.joined(separator: " • ")
                        if !details.isEmpty {
                            Text(details)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        if data.isOngoing {
                            ProgressView(
                                timerInterval: data.startDate...data.endDate,
                                countsDown: false,
                                label: { EmptyView() },
                                currentValueLabel: { EmptyView() }
                            )
                            .tint(.accentColor)
                            .padding(.top, 2)
                        }

                        if !data.afterText.isEmpty {
                            Text(data.afterText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .padding(.top, 2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
                    .padding(.top, 4)
                }
            } compactLeading: {
                LessonLocationLabel(data: data)
            } compactTrailing: {
                LessonTimer(data: data)
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: 54, alignment: .trailing)
            } minimal: {
                LessonIcon(data: data)
            }
            .widgetURL(URL(string: "discipulus://calendar"))
        }
    }
}

// MARK: - Previews

#Preview("Lock Screen", as: .content, using: LiveActivitiesAppAttributes.previewMidLesson) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}

#Preview("Lock Screen – Next", as: .content, using: LiveActivitiesAppAttributes.previewEndingSoon) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: LiveActivitiesAppAttributes.previewMidLesson) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}

#Preview("Compact", as: .dynamicIsland(.compact), using: LiveActivitiesAppAttributes.previewMidLesson) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}

#Preview("Compact – Next", as: .dynamicIsland(.compact), using: LiveActivitiesAppAttributes.previewEndingSoon) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: LiveActivitiesAppAttributes.previewMidLesson) {
    LessonLiveActivityWidget()
} contentStates: {
    LiveActivitiesAppAttributes.ContentState()
}
#endif
