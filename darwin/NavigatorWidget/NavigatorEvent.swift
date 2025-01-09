import SwiftUI

struct Event: Codable, Identifiable {
    let id: Int
    let name: String
    let shortName: String?
    let location: String?
    let infoType: Int
    let startHourIndicator: Int?
    let endHourIndicator: Int?
    let startTime: Date
    let endTime: Date
    let isCompleted: Bool

    func infotypeColor(for colorScheme: ColorScheme, native: Bool = true, noHomework: Bool = false) -> Color {
        if (isCompleted == true) {
            return getWidgetColors(for: colorScheme, native: native).done
        } else if (infoType >= 2 && infoType <= 5) {
            return getWidgetColors(for: colorScheme, native: native).test
        } else {
            return getWidgetColors(for: colorScheme, native: native).primary.opacity(infoType == 0 && !noHomework ? 0.5 : 1)
        }
    }
    
    var infotypeShortString: String? {
        return [nil,"HW","PW","T","SO","MO",nil,nil][infoType]
    }
}

/// Example events that can be used to debug the widget
var sampleEvents: [Event] = 
//[
{
    let calendar = Calendar.current
    let startDate = Date()
    var events: [Event] = []
    
    for i in 0..<5 {
        if let currentDay = calendar.date(byAdding: .day, value: i, to: startDate) {
            for _ in 0..<8 {
                let event = randomEvent(currentDay)
                events.append(event)
            }
        }
    }
    
    return events
}()

//        Event(id: 1, name: "Natuurkunde", shortName: "Nat", location: "109", infoType: 0, startHourIndicator: 4, endHourIndicator: 4, startTime: Date().addingTimeInterval(-3600*24 + 20 * 60 * 3), endTime: Date().addingTimeInterval(-3600*24 + 20 * 60 * 4), isCompleted: false),
//        Event(id: 2, name: "Lichamelijke opvoeding", shortName: "Lo", location: nil, infoType: 0, startHourIndicator: 5, endHourIndicator: 6, startTime: Date().addingTimeInterval(-3600*24 + 20 * 60 * 4), endTime: Date().addingTimeInterval(-3600*24 + 20 * 60 * 6), isCompleted: false),
//        Event(id: 3, name: "Biologie", shortName: "Bio", location: "207", infoType: 0, startHourIndicator: 7, endHourIndicator: 7, startTime: Date().addingTimeInterval(20 * 60 * -6), endTime: Date().addingTimeInterval(20 * 60 * -7), isCompleted: false),
//        Event(id: 4, name: "Nederlandse taal", shortName: "Netl", location: "111", infoType: 1, startHourIndicator: 1, endHourIndicator: 1, startTime: Date().addingTimeInterval(31 * 60), endTime: Date().addingTimeInterval(20 * 60 * 2), isCompleted: false),
//        Event(id: 5, name: "Wiskunde", shortName: "Wis", location: "205", infoType: 1, startHourIndicator: 2, endHourIndicator: 2, startTime: Date().addingTimeInterval(20 * 60 * 2), endTime: Date().addingTimeInterval(20 * 60 * 3), isCompleted: true),
//        Event(id: 6, name: "Filosofie", shortName: "Filo", location: "104", infoType: 2, startHourIndicator: nil, endHourIndicator: nil, startTime: Date().addingTimeInterval(20 * 60 * 3), endTime: Date().addingTimeInterval(20 * 60 * 4), isCompleted: false),
//        Event(id: 7, name: "Natuurkunde", shortName: "Nat", location: "109", infoType: 1, startHourIndicator: 1, endHourIndicator: 4, startTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 3), endTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 4), isCompleted: false),
//        Event(id: 8, name: "Lichamelijke opvoeding", shortName: "Lo", location: nil, infoType: 0, startHourIndicator: 2, endHourIndicator: 6, startTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 4), endTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 6), isCompleted: false),
//        Event(id: 9, name: "Biologie", shortName: "Bio", location: "207", infoType: 0, startHourIndicator: 7, endHourIndicator: 7, startTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 6), endTime: Date().addingTimeInterval(3600*24 + 20 * 60 * 7), isCompleted: false),
//    ]

func randomEvent(_ day: Date) -> Event {
    let name: Optional<(key: String, value: String)> = classNameSeeds.randomElement()
    let date: Date = day.addingTimeInterval(TimeInterval(3600 * Int.random(in: 1..<4)))
    return Event(
        id: day.addingTimeInterval(TimeInterval(Int.random(in: 1..<(24 * 3600)))).hashValue,
        name: name?.key ?? "",
        shortName: name?.value ?? "",
        location: randomClassRoom,
        infoType: Int.random(in: 0..<2),
        startHourIndicator: Int.random(in: 1..<8),
        endHourIndicator: Int.random(in: 1..<8),
        startTime: date,
        endTime: date.addingTimeInterval(TimeInterval(60 * Int.random(in: 30..<60))),
        isCompleted: Int.random(in: 0..<5) == 1
    )
}

var randomClassRoom: String {
    return "\(Int.random(in: 0..<3))\(Int.random(in: 0..<1))\(Int.random(in: 1..<9))"
}

var classNameSeeds: [String: String] = [
    "Wiskunde": "Wis",
    "Nederlandse taal": "Netl",
    "Franse taal": "Frtl",
    "Duitse taal": "Dutl",
    "Engelse taal": "Entl",
    "Natuurkunde": "Nat",
    "Scheikunde": "Sk",
    "Aardrijkskunde": "Ak",
    "Filosofie": "Fi",
    "Economie": "Eco"
]
