import WidgetKit
import AppIntents

struct ConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("Verander instellingen")

    @Parameter(title: "Discipulus kleuren", default: false)
    var useDiscipulusColorscheme: Bool
    
    @Parameter(title: "Type evenementen", default: DisplayedEventType.all)
    var displayedEventType: DisplayedEventType
}

enum DisplayedEventType: String, AppEnum {
    case all
    case homework
    case tests
    case homework_and_tests

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Type evenementen"
    }

    static var caseDisplayRepresentations: [DisplayedEventType: DisplayRepresentation] {
        [
            .all: "Vandaag + Alles",
            .homework: "Vandaag + Huiswerk",
            .tests: "Vandaag + Toetsen",
            .homework_and_tests: "Vandaag + Huiswerk en Toetsen"
        ]
    }
}
